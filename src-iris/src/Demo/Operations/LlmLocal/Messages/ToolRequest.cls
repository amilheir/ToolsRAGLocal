Class Demo.Operations.LlmLocal.Messages.ToolRequest Extends (%Persistent, Ens.Request)
{

/// Input Tool Function.
Property Prompt As %String(MAXLEN = "");

Storage Default
{
<Data name="ToolRequestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Prompt</Value>
</Value>
</Data>
<DataLocation>^Demo.OperationF64A.ToolRequestD</DataLocation>
<DefaultData>ToolRequestDefaultData</DefaultData>
<IdLocation>^Demo.OperationF64A.ToolRequestD</IdLocation>
<IndexLocation>^Demo.OperationF64A.ToolRequestI</IndexLocation>
<StreamLocation>^Demo.OperationF64A.ToolRequestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
