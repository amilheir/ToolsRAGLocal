Class Demo.RecordEmbeddings Extends %Persistent [ DdlAllowed ]
{

Property DataSourceId As %Integer;

Property SourceId As %Integer;

Property Text As %String(MAXLEN = 2048);

Property CleanText As %String(MAXLEN = 2048);

Property Embedding As %Library.Embedding(MODEL = "multilingual-e5-large-instruct", SOURCE = "CleanText");

Index idxDataSourceId On DataSourceId;

Index HNSWIndexD On (Embedding) As %SQL.Index.HNSW(Distance = "DotProduct") [ SqlName = HNSWIndexD, Type = index ];

Storage Default
{
<Data name="RecordEmbeddingsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DataSourceId</Value>
</Value>
<Value name="3">
<Value>SourceId</Value>
</Value>
<Value name="4">
<Value>Text</Value>
</Value>
<Value name="5">
<Value>CleanText</Value>
</Value>
<Value name="6">
<Value>Embedding</Value>
</Value>
</Data>
<DataLocation>^Demo.RecordEmbeddingsD</DataLocation>
<DefaultData>RecordEmbeddingsDefaultData</DefaultData>
<IdLocation>^Demo.RecordEmbeddingsD</IdLocation>
<IndexLocation>^Demo.RecordEmbeddingsI</IndexLocation>
<StreamLocation>^Demo.RecordEmbeddingsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
