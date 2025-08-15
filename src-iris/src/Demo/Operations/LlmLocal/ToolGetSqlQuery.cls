Class Demo.Operations.LlmLocal.ToolGetSqlQuery Extends Ens.BusinessOperation
{

Method OnGenerateRequest(pRequest As Demo.Operations.LlmLocal.Messages.ToolRequestSQL, Output pResponse As Demo.Operations.LlmLocal.Messages.ToolReponseSQL) As %Status
{
    #dim sc As %Status = $$$OK

    Set pResponse = ##class(Demo.Operations.LlmLocal.Messages.ToolReponseSQL).%New()
    Try {
        Set sqlQuery = ..GetQueryJson(pRequest.Data)
        Set pResponse.Result = ..Query(sqlQuery)
    } Catch ex {
        Set sc = ex.AsStatus()
    }
    Quit sc
}

Method Query(sqlQuery) As %String [ Language = python ]
{
    import iris, json
    sqlQuery = sqlQuery.replace("\"","'")
    statement = iris.sql.prepare(f'{sqlQuery}')
    df = statement.execute().dataframe()
    dfs= 'The following select on a sql table was used:'+chr(10)+sqlQuery+chr(10)+'And the result was this:'+chr(10)+df.to_string()
    return dfs
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
  <MapItem MessageType="Demo.Operations.LlmLocal.Messages.ToolRequestSQL">
    <Method>OnGenerateRequest</Method>
  </MapItem>
</MapItems>
}

}
