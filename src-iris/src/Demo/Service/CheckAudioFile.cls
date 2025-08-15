Class Demo.Service.CheckAudioFile Extends Ens.BusinessService
{

Parameter ADAPTER = "EnsLib.File.InboundAdapter";

ClassMethod OnProductionStart() As %Status
{
    Set tSC = $$$OK

    Set tFilePath = "/iris-shared/Input/"
    If '##class(%File).DirectoryExists(tFilePath)
    {
        Do ##class(%File).CreateDirectory(tFilePath) 
        $$$TRACE("Created directory Input.")
    }
    Set tFilePath = "/iris-shared/Archieve/"
    If '##class(%File).DirectoryExists(tFilePath)
    {
        Do ##class(%File).CreateDirectory(tFilePath) 
        $$$TRACE("Created directory Archieve.")
    }
    Quit tSC
}

Method OnProcessInput(pInput As %Stream.Object, Output pOutput As %RegisteredObject) As %Status
{
    Set tSC = $$$OK
    Set tFileName=pInput.Attributes("Filename") 
    Set tResponse = $ZCONVERT(tFileName,"I","UTF8")
    $$$TRACE(tResponse)
    Set text = ##class(Demo.Utils).%New()
    Set Response = ##class(Demo.Utils).GetTextFromAudio(tResponse)
    $$$TRACE(Response)
    Set resp = ##class(%Stream.GlobalCharacter).%New()
    Do resp.Write(Response)
    Set tRequest = ##class(Demo.Operations.Embedding.EmbeddingRequest).%New()
    Set tRequest.Pdf = ##class(Demo.Service.StreamlitService).SaveContent(resp)
    Set tSC = ..SendRequestAsync("Embedding Operation", tRequest)
    Quit tSC
}

}
