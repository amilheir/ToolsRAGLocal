Class Demo.Operations.LlmLocal.Messages.ToolReponseSQL Extends (%Persistent, Ens.Request)
{

Property Result As %String(MAXLEN = "");

Storage Default
{
<Data name="ToolReponseSQLDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Result</Value>
</Value>
</Data>
<DataLocation>^Demo.OperatF64A.ToolReponseSQLD</DataLocation>
<DefaultData>ToolReponseSQLDefaultData</DefaultData>
<IdLocation>^Demo.OperatF64A.ToolReponseSQLD</IdLocation>
<IndexLocation>^Demo.OperatF64A.ToolReponseSQLI</IndexLocation>
<StreamLocation>^Demo.OperatF64A.ToolReponseSQLS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
