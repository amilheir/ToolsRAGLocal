Class Demo.GenerateRequest Extends (%Persistent, Ens.Request)
{

/// Input prompt.
Property Prompt As %String(MAXLEN = "");

Storage Default
{
<Data name="GenerateRequestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Prompt</Value>
</Value>
</Data>
<DataLocation>^Demo.GenerateRequestD</DataLocation>
<DefaultData>GenerateRequestDefaultData</DefaultData>
<IdLocation>^Demo.GenerateRequestD</IdLocation>
<IndexLocation>^Demo.GenerateRequestI</IndexLocation>
<StreamLocation>^Demo.GenerateRequestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
