
# FW/1 Dotenv [![Build Status](https://travis-ci.org/tonyjunkes/fw1dotenv.svg?branch=master)](https://travis-ci.org/tonyjunkes/fw1dotenv)

An FW/1 subsystem for loading external configurations into an application accessible bean object.

## Requirements

* Lucee 5.x+ or Adobe ColdFusion 2016+
* FW/1 4.x+

> Note: FW/1 Dotenv may also be used outside of FW/1 applications but with some obvious limitations. See the `Usage` section for more info.

## Installation

### CommandBox

...TODO...

Installation via ForgeBox/CommandBox coming soon...

### Manual

Include `fw1dotenv` in your FW/1 application's designated `subsystems` directory. If you do not already have a `subsystems` directory, create the directory wherever the rest of your core framework structure lives. You may refer to the [FW/1 Documentation](http://framework-one.github.io/documentation/developing-applications.html#basic-application-structure) for a rundown of a typical structure.

## Configuration

### Default Setup

Configure your FW/1 settings variable to include the location of your settings file and the subsystem's load listener for integrating the settings as a bean.

> Note: The settings file may be any type of readable extension (i.e: .env, .txt, .json, .properties etc.) and contain variables stored in either JSON ({ "key": "value" }) or Properties (key=value) formats.

```cfc
variables.framework = {
    // ... other framework settings
    dotenv: {
        fileName: "/path/to/settings/file/.env"
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

### Creating a Bean Alias

To assign an alternative naming convention to the settings bean, you can include a `beanAlias` key with a name value in the `dotenv` struct.

```cfc
variables.framework = {
    // ... other framework settings
    dotenv: {
        beanAlias: "MyCustomBeanName",
        fileName: "/path/to/settings/file/.env"
    }
    // ... other framework settings
}
```

## Usage

### Default Convention

To access the newly wired settings in your application, you can call the bean from the `fw1dotenv` subsystem bean factory using `getBeanFactory( "fw1dotenv" ).getBean( "SystemSettings" );`.

### Adding to the Parent Bean Factory

If you would like to make the settings bean available to your main/parent bean factory, you can declare it as a new bean in `setupApplication()` or the parent bean factory's `load listener`.

#### setupApplication()

```cfc
setupApplication() {
    // ... some other code
    getBeanFactory().declare( "SystemSettings" ).asValue( getBeanFactory( "fw1dotenv" ).getBean( "SystemSettings" ) );
}
```

#### Load Listener via variables.framework

```cfc
variables.framework = {
    // ... other framework settings
    diEngine: "di1",
    diLocations: [ "/path/to/beans" ],
    diConfig: {
        loadListener: function(di1) {
            di1.declare( "SystemSettings" ).asValue( getBeanFactory( "fw1dotenv" ).getBean( "SystemSettings" ) );
        }
    }
    // ... other framework settings
}
```

#### Load Listener via CFC

```cfc
// Application.cfc (or your alternative config location)
variables.framework = {
    // ... other framework settings
    diEngine: "di1",
    diLocations: [ "/path/to/beans" ],
    diConfig: { loadListener: "MyLoadListener" }
    // ... other framework settings
}

// MyLoadListener.cfc
component {
    public function onLoad( di1 ) {
        var settings = arguments.di1.getBean( "fw" ).getBeanFactory( "fw1dotenv" ).getBean( "SystemSettings" );
        arguments.di1.declare( "SystemSettings" ).asValue( settings );
    }
}
```

### Non-FW/1 Apps

FW/1 Dotenv can be used without FW/1 by instantiating `DotenvService.cfc` and calling `loadSettings()`.

```cfc
dotenvService = new fw1dotenv.model.services.DotenvService();
settings = dotenvService.loadSettings( filePath = "path/to/settings/file/.env" );
```

## Development

### Running Tests With CommandBox & TestBox

From the project root, start CommandBox in your preferred terminal and point to the `/test-harness` directory (`cd test-harness`). Include the test dependencies (FW/1 & TestBox) by running `install`. Start the server by executing `server start`. The server instance will be located at `http://127.0.0.1:8520`.

> Note: By default, the test harness server will use Lucee 5. To use a specific engine/version, either update the `server.json` or run `server start cfengine=[engine]@[version]`.

Once the server has started, you can run `testbox run` in the terminal to execute the tests. To view the test results in the browser, you can navigate to `http://127.0.0.1:8520/tests/runner.cfm`.
