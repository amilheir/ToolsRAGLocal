Class Demo.Operations.LlmLocal.Messages.ToolResponse Extends (%Persistent, Ens.Response)
{

Property Model As %String(MAXLEN = 200);

Property ToolName As %String(MAXLEN = 200);

Property Arguments As %String(MAXLEN = "");

Storage Default
{
<Data name="ToolResponseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Model</Value>
</Value>
<Value name="3">
<Value>ToolName</Value>
</Value>
<Value name="4">
<Value>Arguments</Value>
</Value>
</Data>
<DataLocation>^Demo.OperatioF64A.ToolResponseD</DataLocation>
<DefaultData>ToolResponseDefaultData</DefaultData>
<IdLocation>^Demo.OperatioF64A.ToolResponseD</IdLocation>
<IndexLocation>^Demo.OperatioF64A.ToolResponseI</IndexLocation>
<StreamLocation>^Demo.OperatioF64A.ToolResponseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
