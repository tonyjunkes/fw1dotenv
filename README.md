
# FW/1 Dotenv

An FW/1 subsystem for loading external configurations into an application accessible bean object.

## How to Use

1. Include `fw1dotenv` in your FW/1 application's designated `subsystems` directory. If you do not already have a `subsystems` directory, create the directory wherever the rest of your core framework structure lives. You may refer to the [FW/1 Documentation](http://framework-one.github.io/documentation/developing-applications.html#basic-application-structure) for a rundown of a typical structure.
1. Configure your FW/1 settings to include the location of your settings file and the subsystem's load listener for integrating the settings as a bean.
    ```cfc
	variables.framework = {
	  // ... other framework settings
	  dotenv: {
	    fileName: "/conf/.env"
	  }
	  subsystems: {
	    fw1dotenv: {
	      diLocations: "model",
	      diConfig: {
	        omitDirectoryAliases: true,
	        loadListener: "DotenvListener"
	      }
	    }
	  }
	}
    ```

    > Note: The settings file may be any type of readable extension (.env, txt, json, properties etc.) and contain variables stored in either JSON ({ "key": "value" }) or Properties (key=value) formats.

1. To access the newly wired settings in your application, you can inject the `SystemSettings` bean into your other DI/1 aware beans via `property SystemSettings;` or manually call the bean from the default bean factory with `getBeanFactory().getBean("SystemSettings");`.
