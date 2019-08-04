component
    accessors=true
    output=false
{
    property DotenvService;

    public function onLoad( di1 ) {
        // Get configuration file from framework settings
        var fw1Config = arguments.di1.getBean( "fw" ).getConfig();
        // Load env settings
        var envPath = expandPath( fw1Config?.dotenv?.fileName );
        var settings = variables.DotenvService.loadSettings( filePath = envPath );
        // Load the bean into the parent bean factory
        arguments.di1.declare( "SystemSettings" ).asValue( settings );
        // Setup alias if config exists in framework settings
        var beanAlias = fw1Config?.dotenv?.beanAlias ?: "";
        if ( beanAlias.len() ) {
            arguments.di1.declare( beanAlias ).aliasFor( "SystemSettings" );
        }
    }
}