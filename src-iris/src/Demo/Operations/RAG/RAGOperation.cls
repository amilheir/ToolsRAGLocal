Class Demo.Operations.RAG.RAGOperation Extends Ens.BusinessOperation
{

Parameter SETTINGS = "NumberOfRetrivals:RAG";

Property NumberOfRetrivals As %String [ InitialExpression = "3" ];

Method OnRAG(pRequest As Demo.GenerateRequest, pResponse As Demo.Operations.RAG.RAGResponse) As %Status
{
    Set tSc = $$$OK

    Try {
      Set tBuiltins = ##class(%SYS.Python).Builtins()
      Set tList = tBuiltins.list()
      Set tAsk = ..GetQueryJson(pRequest.Prompt)
      Set tPrompt = ##class(Demo.Utils).GetCleanTxt(tAsk)
      Set tStatement = ##class(%SQL.Statement).%New()
      Set tSql = "SELECT TOP "_..NumberOfRetrivals_" ID FROM Demo.RecordEmbeddings ORDER BY VECTOR_DOT_PRODUCT(Embedding, EMBEDDING(?)) DESC"
      Set rList = ##class(%SQL.Statement).%ExecDirect(, tSql, tPrompt)
      Set pResponse = ##class(Demo.Operations.RAG.RAGResponse).%New()
      Set tRowCount = 0
      While rList.%Next(){
          Set pResponse.DocIds = pResponse.DocIds_","_rList.%Get("ID")
          Set tRowCount = tRowCount + 1
      }
      Set pResponse.DocCount = tRowCount
    } Catch ex {
        Set tSc = ex.AsStatus()
    }
    Return tSc
}

ClassMethod GetQueryJson(text) As %String [ Language = python ]
{
    
    import json
    query = json.loads(text)[0]["query"]
    return query
}

XData MessageMap
{
<MapItems>
  <MapItem MessageType="Demo.GenerateRequest">
    <Method>OnRAG</Method>
  </MapItem>
</MapItems>
}

}
