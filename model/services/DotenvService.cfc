component
    output=false
{
    public DotenvService function init() {
        return this;
    }

    public function loadSettings( required string filePath ) {
        var envVars = {};
        if ( fileExists( arguments.filePath ) ) {
            var envFile = fileRead( arguments.filePath );
            // If JSON, deserialize natively
            if ( isJSON( envFile ) ) {
                envVars = deserializeJSON( envFile );
            } else {
                // Otherwise load as properties format and convert to CFML struct
                var FileInputStream = createObject( "java", "java.io.FileInputStream" );
                var Properties = createObject( "java", "java.util.Properties" ).init();
                Properties.load( FileInputStream.init( arguments.filePath ) );
                Properties.each(function( prop ) {
                    envVars[ arguments.prop ] = Properties[ arguments.prop ];
                });
            }
        } else {
            // Throw error if no file can be found
            throw( "[fw1dotenv]: Could not find environment file." );
        }

        return envVars;
    }
}