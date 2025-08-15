Class Demo.Operations.LlmLocal.ToolPrompt Extends Ens.BusinessOperation
{

Method OnPrompt(pRequest As Demo.Operations.LlmLocal.Messages.ToolPromptRequest, pResponse As Demo.Operations.LlmLocal.Messages.ToolPromptResponse) As %Status
{
    Set tSc = $$$OK
    Try {
      Set pResponse = ##class(Demo.Operations.LlmLocal.Messages.ToolPromptResponse).%New()
      Set tContextString = "Context: "_pRequest.Result_$CHAR(10)
      Set tPromptString = "Prompt: " _ pRequest.Prompt
      Set tPrompt = tContextString_tPromptString
      Set pResponse.Prompt = tPrompt
    } Catch tEx {
        Set tSc = tEx.AsStatus()
    }
    Return tSc
}

XData MessageMap
{
<MapItems>
  <MapItem MessageType="Demo.Operations.LlmLocal.Messages.ToolPromptRequest">
    <Method>OnPrompt</Method>
  </MapItem>
</MapItems>
}

}
