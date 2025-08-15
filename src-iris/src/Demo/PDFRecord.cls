Class Demo.PDFRecord Extends (%Persistent, %JSON.Adaptor)
{

Property Text As %String(MAXLEN = "");

Storage Default
{
<Data name="PDFRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Text</Value>
</Value>
</Data>
<DataLocation>^Demo.PDFRecordD</DataLocation>
<DefaultData>PDFRecordDefaultData</DefaultData>
<ExtentSize>5</ExtentSize>
<IdLocation>^Demo.PDFRecordD</IdLocation>
<IndexLocation>^Demo.PDFRecordI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>2</AverageFieldSize>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="Text">
<AverageFieldSize>52547.6</AverageFieldSize>
<Selectivity>20.0000%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-144</BlockCount>
</SQLMap>
<StreamLocation>^Demo.PDFRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
