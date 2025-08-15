Class Demo.Operations.LlmLocal.GetSQLInfo Extends Ens.BusinessOperation
{

Method OnGenerateRequest(pRequest As Demo.Operations.LlmLocal.Messages.ToolRequestSQL, Output pResponse As Demo.Operations.LlmLocal.Messages.ToolReponseSQL) As %Status
{
    #dim sc As %Status = $$$OK

    Set pResponse = ##class(Demo.Operations.LlmLocal.Messages.ToolReponseSQL).%New()
    Try {
        Set columnName = ..GetQueryJson(pRequest.Data)
        Set pResponse.Result = ..Query(columnName)
    } Catch ex {
        Set sc = ex.AsStatus()
    }
    Quit sc
}

Method Query(columnName) As %String [ Language = python ]
{
    import iris, json
    statement = iris.sql.prepare(f'SELECT {columnName} AS {columnName}, COUNT(*) AS occurrences FROM Demo.SupportTickets GROUP BY {columnName} ORDER BY occurrences DESC')
    df = statement.execute().dataframe()
    dfs= df.to_string()
    return dfs
}

ClassMethod GetQueryJson(text) As %String [ Language = python ]
{
    import json
    query = json.loads(text)[0]["column_name"]
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
