package com.pearson.ras.service;

import java.util.Hashtable;

import javax.naming.NamingException;
import javax.naming.ldap.InitialLdapContext;
import javax.naming.ldap.LdapContext;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class LDAPAuthentication {

	static Logger log = LogManager.getLogger(LDAPAuthentication.class.getName());

	public boolean LDAPUserAuthentic(String username, String password) throws NamingException {
		LdapContext ctx = null;

		try {

			if ((password.equals(" ")) || (password == null) || (password.trim().isEmpty())) {

				log.info("INVALID CREDENTIALS");

				return false;
			}
			log.error("Login name:" + username + "Password:" + password);

			Hashtable env = new Hashtable();
			env.put("java.naming.factory.initial", "com.sun.jndi.ldap.LdapCtxFactory");
			env.put("java.naming.security.authentication", "Simple");

			env.put("java.naming.security.principal", username);
			env.put("java.naming.security.credentials", password);
			env.put("java.naming.provider.url", "LDAP://LSK12.COM");

			env.put("java.naming.provider.url", "LDAP://10.16.17.11");
			env.put("java.naming.provider.url", "LDAP://10.16.17.12");
			env.put("java.naming.provider.url", "LDAP://10.16.81.11");
			env.put("java.naming.provider.url", "LDAP://10.16.81.12");

			ctx = new InitialLdapContext(env, null);
			if (ctx != null) {
				log.error("LDAP LOGIN SUCCESSFULL FOR THE USER==>" + username);
				return true;
			}
		} catch (NamingException nex) {
			if (ctx != null)
				ctx.close();
			log.info("INVALID_LOGIN_CREDENTIALS" + nex);
			log.error(nex.getMessage());
			nex.printStackTrace();

		} catch (Exception e) {
			log.error(e.getMessage());
			e.printStackTrace();

		}
		return false;

	}

}
