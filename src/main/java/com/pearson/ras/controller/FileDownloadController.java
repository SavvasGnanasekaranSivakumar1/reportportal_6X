package com.pearson.ras.controller;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.logging.Logger;
import jakarta.servlet.ServletContext;
import jakarta.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.itextpdf.text.Document;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.pdf.PdfContentByte;
import com.itextpdf.text.pdf.PdfImportedPage;
import com.itextpdf.text.pdf.PdfReader;
import com.itextpdf.text.pdf.PdfStamper;
import com.itextpdf.text.pdf.PdfWriter;

@Controller
@RequestMapping("/files")
public class FileDownloadController {

	private static final Logger log = Logger.getLogger("com.pearson.ras.controller.FileDownloadController");

	@Value("#{appProps['app.pdfreportsdir']}")
	private String pdfRepDir;

	private @Autowired ServletContext servletContext;

	@RequestMapping(value = "/pdffile", method = RequestMethod.GET)
	public void getFile(@RequestParam("fileloc") String fileLoc, HttpServletResponse response) {
		try {
			// get file as InputStream
			if (fileLoc != null)
				fileLoc = fileLoc.trim();

			String filePath = pdfRepDir + File.separatorChar + fileLoc;

			System.out.println("pdf donwload filepath: " + filePath);
			File fileIn = new File(filePath);
			InputStream is = new FileInputStream(fileIn);

			response.setContentType("text/plain");
			response.addHeader("Content-Disposition", "attachment;filename=report.pdf");

			if (is == null)
				System.out.println("input stream null");

			// copy it to response's OutputStream
			int size = FileCopyUtils.copy(is, response.getOutputStream());

			System.out.println(size);

			response.flushBuffer();

		} catch (IOException ex) {
			System.out.println("Exception: " + ex.getMessage());
			throw new RuntimeException("IOError writing file to output stream");
		}
	}

	@RequestMapping(value = "/pdfprintingfile", method = RequestMethod.GET)
	public void getPrintFile(@RequestParam("fileloc") String fileLoc, @RequestParam("startPage") String startPage,
			@RequestParam("endPage") String endPage, HttpServletResponse response) {
		try {
			int fromPage = Integer.parseInt(startPage);
			int toPage = Integer.parseInt(endPage);

			// get file as InputStream
			if (fileLoc != null)
				fileLoc = fileLoc.trim();

			String filePath = pdfRepDir + File.separatorChar + fileLoc;

			System.out.println("pdf donwload filepath: " + filePath);
			File fileIn = new File(filePath);
			InputStream is = new FileInputStream(fileIn);
			// response.setContentType("application/pdf");

			// Splitting the File - Start
			// ByteArrayOutputStream outputStream = new ByteArrayOutputStream();

			FileOutputStream outputStream = new FileOutputStream(
					new File(pdfRepDir + File.separatorChar + "tempprint" + File.separatorChar + "temp" + fileLoc));

			Document document = new Document(PageSize.A4);

			PdfReader inputPDF = new PdfReader(is);
			int totalPages = inputPDF.getNumberOfPages();
			// make fromPage equals to toPage if it is greater
			if (fromPage > toPage) {
				fromPage = toPage;
			}
			if (toPage > totalPages) {
				toPage = totalPages;
			}
			// Create a writer for the outputstream
			// PdfWriter writer = PdfWriter.getInstance(document, outputStream);

			PdfWriter writer = PdfWriter.getInstance(document, outputStream);
			writer.setViewerPreferences(inputPDF.getSimpleViewerPreferences());
			document.open();
			PdfContentByte cb = writer.getDirectContent();
			// Holds the PDF data
			PdfImportedPage page;
			while (fromPage <= toPage) {
				page = writer.getImportedPage(inputPDF, fromPage);
				float importedPageXYRatio = page.getWidth() / page.getHeight();
				if (importedPageXYRatio > 1f) {
					document.setPageSize(PageSize.A4.rotate());
				} else {
					document.setPageSize(PageSize.A4);
				}
				document.newPage();
				float truePageWidth = document.getPageSize().getWidth() - document.leftMargin()
						- document.rightMargin();
				float truePageHeight = document.getPageSize().getHeight() - document.topMargin()
						- document.bottomMargin();
				float x = (truePageWidth - page.getWidth()) / 2 + document.rightMargin();
				float y = (truePageHeight - page.getHeight()) / 2 + document.bottomMargin();
				cb.addTemplate(page, x, y);
				// cb.addTemplate(page, 0, 0);
				fromPage++;
			}

			document.close();
			outputStream.close();

			// Splitting File Ends

			// Add code to print the pdf start
			/*
			 * writer.setEncryption(null, null, PdfWriter.ALLOW_PRINTING,
			 * PdfWriter.ENCRYPTION_AES_128 | PdfWriter.DO_NOT_ENCRYPT_METADATA);
			 */

			// Add code to print the pdf End

			response.setContentType("application/pdf");
			response.addHeader("Content-Disposition", "inline; filename=report.pdf");

			//
			if (is == null)
				System.out.println("input stream null");
			// copy it to response's OutputStream

			// FileCopyUtils.copy(is, response.getOutputStream());

			response.getOutputStream().write(
					printpdf(pdfRepDir + File.separatorChar + "tempprint" + File.separatorChar + "temp" + fileLoc));

			response.flushBuffer();

		} catch (IOException ex) {
			System.out.println("Exception: " + ex.getMessage());
			throw new RuntimeException("IOError writing file to output stream");
		} catch (Exception exception) {
			exception.printStackTrace();
		}

	}

	public static byte[] printpdf(String flName) {
		byte[] pdfByte = null;

		PdfReader reader = null;
		PdfStamper stamper = null;
		FileOutputStream outputStream = null;
		ByteArrayOutputStream baos = new ByteArrayOutputStream();

		try {

			reader = new PdfReader(flName);

			/** Stamper to update the properties and data */
			// outputStream = new FileOutputStream(docPath + "temp.pdf");
			stamper = new PdfStamper(reader, baos);

			/** Set PDF properties */
			stamper.setEncryption(null, null, PdfWriter.ALLOW_PRINTING,
					PdfWriter.ENCRYPTION_AES_128 | PdfWriter.DO_NOT_ENCRYPT_METADATA);

			String scriptToPrintTheDoc = "     this.print(" + "           {     bUI: true,"
					+ "                   bSilent: false," + "                   bShrinkToFit: false"
					+ "           });";
			stamper.addJavaScript(scriptToPrintTheDoc);

			stamper.close();

			pdfByte = baos.toByteArray();

		} catch (Exception exception) {
			System.out.println("Exception occured. PDF cannot be generated ");
			exception.printStackTrace();
		} finally {
			try {
				if (null != stamper)
					stamper.close();
				if (null != reader)
					reader.close();
				new FileDownloadController().deleteFiles(flName);
			} catch (Exception exception1) {
				System.out.println("Error occurred while closing the file ");
				exception1.printStackTrace();
			}
		}

		if (pdfByte == null) {
			System.out.println("PDF not found");
			return pdfByte;
		} else {
			return pdfByte;
		}
	}

	public void deleteFiles(String filename) {
		File file = new File(filename);
		boolean isdeleted = file.delete();
		if (isdeleted)
			log.info("temp" + file + "  deleted after print" + isdeleted);
		else
			log.info("temp" + file + " not deleted. Error ");
	}
}
