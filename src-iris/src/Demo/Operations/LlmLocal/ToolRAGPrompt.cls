Class Demo.Operations.LlmLocal.ToolRAGPrompt Extends Ens.BusinessOperation
{

Method OnPrompt(pRequest As Demo.Operations.Prompt.PromptRequest, pResponse As Demo.Operations.Prompt.PromptResponse) As %Status
{
    Set tSc = $$$OK
    Try {
      Set tDoclist = $LISTFROMSTRING(pRequest.DocIds,",")
      Set pResponse = ##class(Demo.Operations.Prompt.PromptResponse).%New()
      Set tContextString = "Context: "_$CHAR(10)
      For i=2:1:$LISTLENGTH(tDoclist) {
          Set a = i - 1 
          Set tDoc = ..GetValue(pRequest.Column, $LIST(tDoclist, i))
          Set tContextString = tContextString_a_" - "_tDoc_$CHAR(10)
      }
      Set tPromptString = "Prompt: " _ pRequest.Prompt
      Set tPrompt = tContextString _ " " _ tPromptString
      Set pResponse.Prompt = tPrompt
    } Catch tEx {
        Set tSc = tEx.AsStatus()
    }
    Return tSc
}

ClassMethod GetValue(column As %String, ID As %Integer) As %String [ Language = python ]
{
    import json
    import iris
    obj = iris.cls('Demo.SupportTickets')._OpenId(ID) 
    column1 = "InternalNotes"
    text1 = getattr(obj, column1)
    column2 = "Description"
    #column =  column[:-3]  # remove 'Emb' suffix
    text2 = getattr(obj, column2)
    text =  column1 + ": " + text1  + " Description: "+text2
    return text
}

XData MessageMap
{
<MapItems>
  <MapItem MessageType="Demo.Operations.Prompt.PromptRequest">
    <Method>OnPrompt</Method>
  </MapItem>
</MapItems>
}

}
