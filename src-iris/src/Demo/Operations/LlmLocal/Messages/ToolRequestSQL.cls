Class Demo.Operations.LlmLocal.Messages.ToolRequestSQL Extends (%Persistent, Ens.Request)
{

Property Data As %String(MAXLEN = "");

Storage Default
{
<Data name="ToolRequestSQLDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Data</Value>
</Value>
</Data>
<DataLocation>^Demo.OperatF64A.ToolRequestSQLD</DataLocation>
<DefaultData>ToolRequestSQLDefaultData</DefaultData>
<IdLocation>^Demo.OperatF64A.ToolRequestSQLD</IdLocation>
<IndexLocation>^Demo.OperatF64A.ToolRequestSQLI</IndexLocation>
<StreamLocation>^Demo.OperatF64A.ToolRequestSQLS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
