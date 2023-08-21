package nosi.base.ActiveRecord;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.hibernate.SessionFactory;
import org.hibernate.boot.registry.StandardServiceRegistry;
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;
import org.hibernate.cfg.Configuration;
import org.hibernate.service.ServiceRegistry;

import nosi.core.config.ConfigApp;
import nosi.core.webapp.Core;

/**
 * Emanuel
 * 29 May 2018
 */

public class HibernateUtils {

    private static final Logger LOG = LogManager.getLogger(HibernateUtils.class);

    private static final Map<String, SessionFactory> SESSION_FACTORY = new HashMap<>();
    private static final SessionFactory SESSION_FACTORY_IGRP;
    public static final StandardServiceRegistryBuilder REGISTRY_BUILDER_IGRP;

    public static final String SUFIX_HIBERNATE_CONFIG = ".cfg.xml";

    private HibernateUtils() {
        throw new IllegalStateException("Utility class");
      }
    static {
        String cfgName = ConfigApp.getInstance().getBaseConnection() + SUFIX_HIBERNATE_CONFIG;
        Properties properties = getProperties(ConfigApp.getInstance().getBaseConnection()+".properties");
		
        REGISTRY_BUILDER_IGRP = new StandardServiceRegistryBuilder().applySettings(properties).configure(cfgName);
        SESSION_FACTORY_IGRP = buildSessionFactory(cfgName);
    }
    


	

    public static SessionFactory getSessionFactory(String connectionName) {
        return getSessionFactory(connectionName, Core.getCurrentDadParam());
    }

    public static SessionFactory getSessionFactory(String connectionName, String dad) {

        if (connectionName != null && connectionName.equalsIgnoreCase(ConfigApp.getInstance().getBaseConnection()))
            return SESSION_FACTORY_IGRP;

        final String fileName = dad != null && !dad.isEmpty() ? connectionName + "." + dad : connectionName;

        SessionFactory sessionFactory = SESSION_FACTORY.computeIfAbsent(connectionName, sf -> buildSessionFactory(fileName + SUFIX_HIBERNATE_CONFIG));

        if (sessionFactory != null && sessionFactory.isOpen())
            return sessionFactory;

        removeSessionFactory(connectionName);

        sessionFactory = buildSessionFactory(fileName + SUFIX_HIBERNATE_CONFIG);
        SESSION_FACTORY.put(connectionName, sessionFactory);

        return sessionFactory;
    }

    private static SessionFactory buildSessionFactory(String cfgName) {
        try {
            ServiceRegistry serviceRegistry;
            if (cfgName.startsWith(ConfigApp.getInstance().getBaseConnection()))
                serviceRegistry = REGISTRY_BUILDER_IGRP.build();
            else
                serviceRegistry = getServiceRegistryBuilder(cfgName).build();
                  
            return new Configuration().buildSessionFactory(serviceRegistry);
        } catch (Exception ex) {
            LOG.error("Initial SessionFactory creation failed.", ex);
            throw new ExceptionInInitializerError(ex);
        }
    }

    public static Map<String, Object> getSettings(){
    	return HibernateUtils.REGISTRY_BUILDER_IGRP.getSettings();
    	
    }

	private static StandardServiceRegistryBuilder getServiceRegistryBuilder(String cfgName) {
		return new StandardServiceRegistryBuilder().applySettings(getProperties(cfgName.replace(SUFIX_HIBERNATE_CONFIG, ".properties"))).configure(cfgName);
	}
	
	  public static Map<String, Object> getSettings(String cfgName){
		  return getServiceRegistryBuilder(cfgName).getSettings();
	  }
	
	

    public static synchronized void unregisterAllDrivers() {
        final Enumeration<Driver> drivers = DriverManager.getDrivers();
        while (drivers.hasMoreElements()) {
            try {
                DriverManager.deregisterDriver(drivers.nextElement());
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public static void closeAllConnection() {
        SESSION_FACTORY.values().forEach(SessionFactory::close);
        if (SESSION_FACTORY_IGRP != null)
            SESSION_FACTORY_IGRP.close();
    }

    public static void removeSessionFactory(String connectionName) {
        final SessionFactory sessionFactory = SESSION_FACTORY.remove(connectionName);
        if (null != sessionFactory && sessionFactory.isOpen())
            sessionFactory.close();
    }
    
    private static Properties getProperties(String fileName) {
		Properties properties = new Properties();
          	try (InputStream inputStream = HibernateUtils.class.getClassLoader().getResourceAsStream(fileName)) {
    			if (inputStream != null)
    				properties.load(inputStream);
    		} catch (IOException e) {
				e.printStackTrace();
			}
		return properties;
	}
}