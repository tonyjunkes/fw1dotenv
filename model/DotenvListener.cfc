component
    accessors=true
    output=false
{
    property fw;

    public function onLoad( di1 ) {
        // Get configuration file from framework subsystem settings
        var envFilePath = expandPath( variables.fw.getConfig()?.dotenv?.fileName );
        if ( fileExists( envFilePath ) ) {
            var envFile = fileRead( envFilePath );
            // If JSON, deserialize natively and include as bean
            if ( isJSON( envFile ) ) {
                // Load the bean into the parent bean factory
                variables.fw.getBeanFactory().declare( "SystemSettings" ).asValue( deserializeJSON( envFile ) );
            } else {
                // Otherwise load as properties format and include as bean
                var FileInputStream = createObject( "java", "java.io.FileInputStream" );
                var Properties = createObject( "java", "java.util.Properties" ).init();
                Properties.load( FileInputStream.init( envFilePath ) );
                // To avoid case sensitivity issues when accessing key/value pairs
                var envVars = {};
                Properties.each(function( prop ) {
                    envVars[ arguments.prop ] = Properties[ arguments.prop ];
                });
                // Load the bean into the parent bean factory
                variables.fw.getBeanFactory().declare( "SystemSettings" ).asValue( envVars );
            }
        } else {
            // Print to console if no file can be found
            var System = createObject( "java", "java.lang.System" );
            System.out.println( "[fw1dotenv]: Cannot find environment file." );
        }
    }
}