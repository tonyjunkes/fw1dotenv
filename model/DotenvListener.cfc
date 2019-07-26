component
    output=false
{
    public function onLoad( di1 ) {
        // Get configuration file from framework subsystem settings
        var envFilePath = expandPath( di1.getBean( "fw" ).getConfig()?.dotenv?.fileName );
        if ( fileExists( envFilePath ) ) {
            var envFile = fileRead( envFilePath );
            // If JSON, deserialize natively and include as bean
            if ( isJSON( envFile ) ) {
                di1.declare( "SystemSettings" ).asValue( deserializeJSON( envFile ) );
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
                di1.declare( "SystemSettings" ).asValue( envVars );
            }
        } else {
            // Print to console if no file can be found
            var System = createObject( "java", "java.lang.System" );
            System.out.println( "[fw1dotenv]: Cannot find environment file." );
        }
    }
}