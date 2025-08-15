Class Demo.Operations.LlmLocal.Messages.ToolResultResponse Extends (%Persistent, Ens.Response)
{

Property Result As %String(MAXLEN = "");

Storage Default
{
<Data name="ToolResultResponseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Result</Value>
</Value>
</Data>
<DataLocation>^Demo.OperaF64A.ToolResultRe79AD</DataLocation>
<DefaultData>ToolResultResponseDefaultData</DefaultData>
<IdLocation>^Demo.OperaF64A.ToolResultRe79AD</IdLocation>
<IndexLocation>^Demo.OperaF64A.ToolResultRe79AI</IndexLocation>
<StreamLocation>^Demo.OperaF64A.ToolResultRe79AS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
