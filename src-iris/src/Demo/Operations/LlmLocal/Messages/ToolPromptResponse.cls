Class Demo.Operations.LlmLocal.Messages.ToolPromptResponse Extends (%Persistent, Ens.Response)
{

Property Prompt As %String(MAXLEN = "");

Storage Default
{
<Data name="ToolPromptResponseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Prompt</Value>
</Value>
</Data>
<DataLocation>^Demo.OperaF64A.ToolPromptRF7C2D</DataLocation>
<DefaultData>ToolPromptResponseDefaultData</DefaultData>
<IdLocation>^Demo.OperaF64A.ToolPromptRF7C2D</IdLocation>
<IndexLocation>^Demo.OperaF64A.ToolPromptRF7C2I</IndexLocation>
<StreamLocation>^Demo.OperaF64A.ToolPromptRF7C2S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
