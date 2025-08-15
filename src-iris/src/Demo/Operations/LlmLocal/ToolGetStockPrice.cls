Class Demo.Operations.LlmLocal.ToolGetStockPrice Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

XData MessageMap
{
<MapItems>
  <MapItem MessageType="Demo.Operations.LlmLocal.Messages.ToolResultRequest">
    <Method>OnGenerateRequest</Method>
  </MapItem>
</MapItems>
}

Method OnGenerateRequest(pRequest As Demo.Operations.LlmLocal.Messages.ToolResultRequest, Output pResponse As Demo.Operations.LlmLocal.Messages.ToolResultResponse) As %Status
{
    #dim sc As %Status = $$$OK
    Set pResponse = ##class(Demo.Operations.LlmLocal.Messages.ToolResultResponse).%New()
    Try {
        Set pResponse.Result = ..GenerateRequest(pRequest)
    } Catch ex {
        Set sc = ex.AsStatus()
    }

    Quit sc
}

Method GenerateRequest(pRequest As Demo.Operations.LlmLocal.Messages.ToolResultRequest) As %String [ Language = python ]
{
    import yfinance as yf
    from datetime import datetime 
    import json
    """
    Get the current stock price for a given symbol
    Args:
        symbol (str): The stock symbol (e.g., AAPL, GOOGL)
    Returns:
        float: The current stock price
    """
    current_datetime = datetime.fromisoformat(datetime.now().isoformat(timespec='minutes'))
    symbol = json.loads(pRequest.Arguments)[0]["symbol"]
    ticker = yf.Ticker(symbol)
    fast_info = ticker.fast_info
    if hasattr(fast_info, 'last_price') and fast_info.last_price is not None:
        result = symbol+' Stock Price: '+str(fast_info.last_price)+' '+ticker.fast_info.currency+' on the time '+str(current_datetime)
        return result
}

ClassMethod LogInfo(Msg As %String)
{
    $$$LOGINFO(Msg)
}

ClassMethod Trace(Msg As %String)
{
    $$$TRACE(Msg)
}

}
