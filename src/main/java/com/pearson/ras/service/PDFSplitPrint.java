package com.pearson.ras.service;

import java.io.*;

import com.itextpdf.text.Document;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.pdf.PdfContentByte;
import com.itextpdf.text.pdf.PdfImportedPage;
import com.itextpdf.text.pdf.PdfReader;
import com.itextpdf.text.pdf.PdfStamper;
import com.itextpdf.text.pdf.PdfWriter;

public class PDFSplitPrint {
	public static String splitPDF(String inputfile, String outputfile, int fromPage, int toPage) {
		InputStream inputStream = null;
		OutputStream outputStream = null;

		Document document = new Document(PageSize.A4.rotate());
		try {
			inputStream = new FileInputStream(new File(inputfile));
			outputStream = new FileOutputStream(new File(outputfile));
			PdfReader inputPDF = new PdfReader(inputStream);
			int totalPages = inputPDF.getNumberOfPages();
			// make fromPage equals to toPage if it is greater
			if (fromPage > toPage) {
				fromPage = toPage;
			}
			if (toPage > totalPages) {
				toPage = totalPages;
			}
			// Create a writer for the outputstream
			PdfWriter writer = PdfWriter.getInstance(document, outputStream);
			document.open();
			PdfContentByte cb = writer.getDirectContent();
			// Holds the PDF data
			PdfImportedPage page;
			while (fromPage <= toPage) {
				document.newPage();
				page = writer.getImportedPage(inputPDF, fromPage);
				cb.addTemplate(page, 0, 0);
				fromPage++;
			}
			outputStream.flush();
			document.close();
			outputStream.close();
			return "Success";
		} catch (Exception e) {
			e.printStackTrace();
			return "Failed";
		} finally {
			if (document.isOpen())
				document.close();
			try {
				if (outputStream != null)
					outputStream.close();
			} catch (IOException ioe) {
				ioe.printStackTrace();
			}
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
					+ "                   bSilent: false," + "                   bShrinkToFit: true" + "           });";
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
}
