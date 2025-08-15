Class Demo.Operations.LlmLocal.ToolRAG Extends Ens.BusinessOperation
{

Parameter SETTINGS = "NumberOfRetrivals:RAG";

Property NumberOfRetrivals As %String [ InitialExpression = "3" ];

Method OnRAG(pRequest As Demo.GenerateRequest, pResponse As Demo.Operations.RAG.RAGResponse) As %Status
{
    Set tSc = $$$OK

    Try {
      Set tBuiltins = ##class(%SYS.Python).Builtins()
      Set tList = tBuiltins.list()


      Set tquery = ..GetQueryJson(pRequest.Prompt, "query")
      Set tcolumn = ..GetQueryJson(pRequest.Prompt, "column_name")
      Set tStatement = ##class(%SQL.Statement).%New()
      Set tSql = "SELECT TOP "_..NumberOfRetrivals_" ID FROM Demo.SupportTickets ORDER BY VECTOR_DOT_PRODUCT("_tcolumn_" , EMBEDDING('"_tquery_"')) DESC"
      $$$TRACE(tSql)
      Set rList = ..Query(tSql)

      Set pResponse = ##class(Demo.Operations.RAG.RAGResponse).%New()
      
      Set pResponse.DocIds = rList
      Set pResponse.DocCount = ..NumberOfRetrivals
      Set pResponse.Column = tcolumn
    } Catch ex {
        Set tSc = ex.AsStatus()
    }
    Return tSc
}

Method Query(sqlQuery) As %List [ Language = python ]
{
    import iris
    statement = iris.sql.exec(sqlQuery)
    df  = statement.dataframe()
    list = df.stack().tolist()

    formatted_data = ','.join(str(item) for item in list)
    formatted_data =","+formatted_data
    return formatted_data
}

ClassMethod GetQueryJson(text, column) As %String [ Language = python ]
{
    import json
    query = json.loads(text)[0][column]
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
