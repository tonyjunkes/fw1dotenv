component {
    this.name = "FW1DotenvTestingSuite" & hash(getCurrentTemplatePath());
    variables.testsPath = getDirectoryFromPath( getCurrentTemplatePath() );
    this.mappings = {
        "/tests": variables.testsPath,
        "/resources": variables.testsPath & "./resources",
        "/testbox": variables.testsPath & "../testbox",
        "/framework": variables.testsPath & "../framework",
        "/model": variables.testsPath & "../../model"
    };
}