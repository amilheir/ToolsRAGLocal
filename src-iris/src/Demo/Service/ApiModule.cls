Class Demo.Service.ApiModule Extends apiPub.core.service
{

/// Target path for OAS Documentation
Parameter OASPath As %String = "Get:/_spec";

/// Target class that contains all API (Web Methods) for this module
Parameter DispatchClass As %String = "Demo.Service.StreamlitService";

/// When the class is also a Business Service
Parameter DispatchBSName As %String = "Streamlit Service";

/// Use IRIS Production to generate tracing and monitoring (dashboards)
Parameter Traceable As %Boolean = 0;

/// Group for monitoring
Parameter APIDomain = "Rag";

/// If OASNestedMode=1 publisher avoid name conflict for OAS Schemas (Complex Requests and Responses)
Parameter OASNestedMode = 1;

/// format/prettify the JSON request body
Parameter BeautifyJsonBodyRequest = 0;

/// format/prettify the JSON response body
Parameter BeautifyJsonBodyResponse = 0;

}
