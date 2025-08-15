Class Demo.Operations.LlmLocal.Messages.ToolPromptRequest Extends (%Persistent, Ens.Request)
{

Property Result As %String(MAXLEN = "");

Property Prompt As %String(MAXLEN = "");

Storage Default
{
<Data name="ToolPromptRequestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Prompt</Value>
</Value>
<Value name="3">
<Value>Result</Value>
</Value>
</Data>
<DataLocation>^Demo.OperaF64A.ToolPromptRDF3ED</DataLocation>
<DefaultData>ToolPromptRequestDefaultData</DefaultData>
<IdLocation>^Demo.OperaF64A.ToolPromptRDF3ED</IdLocation>
<IndexLocation>^Demo.OperaF64A.ToolPromptRDF3EI</IndexLocation>
<StreamLocation>^Demo.OperaF64A.ToolPromptRDF3ES</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
