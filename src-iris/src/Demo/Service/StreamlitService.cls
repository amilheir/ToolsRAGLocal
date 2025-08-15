Class Demo.Service.StreamlitService Extends Ens.BusinessService
{

/// Configuration item(s) to which to send file stream messages
Property TargetConfigName As %String(MAXLEN = 1000);

Parameter SETTINGS = "TargetConfigName:Basic:selector?context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId}";

/// @apiPub[path="Ask"]
Method PromptAsk(pPrompt As %String) As %String [ WebMethod ]
{
    Set tRequest = ##class(Demo.GenerateRequest).%New()
    Set tRequest.Prompt = $ZCONVERT(pPrompt,"I","UTF8")

    Set tSC = ..SendRequestSync(..TargetConfigName, tRequest, .tResponse)

    Return tResponse.Response
}

Method Ask(pPrompt As %String) As %String
{
    Set tRequest = ##class(Demo.GenerateRequest).%New()
    Set tResponse = ##class(Demo.GenerateResponse).%New()
    Set tRequest.Prompt = pPrompt

    Set tSC = ..SendRequestSync(..TargetConfigName, tRequest, .tResponse)

    Return tResponse.Response
}

/// persists this content and vectorized it  
/// @apiPub[params.text.inputType="text/html"]
/// @apiPub[charset="UTF-8"]
Method SubmitContent(text As %Stream.GlobalCharacter) As Demo.PDFRecord [ WebMethod ]
{
    Set tStream = ##class(%Stream.GlobalCharacter).%New()
    Do text.Rewind()
    Set tContent = ""
    While text.AtEnd'=1 {
        Do tStream.Write($ZCONVERT(text.Read(),"I","UTF8"))
    }
    Set tRequest = ##class(Demo.Operations.Embedding.EmbeddingRequest).%New()
    Set tRequest.Pdf = ..SaveContent(tStream)
    Set tSC = ..SendRequestAsync("Embedding Operation", tRequest)
    Quit ##Class(Demo.PDFRecord).%OpenId(tRequest.Pdf)
}

ClassMethod SaveContent(text As %Stream.GlobalCharacter) As %Integer
{
    Do text.Rewind()
    Set tContent = ""
    While text.AtEnd'=1 {
        Set tContent = tContent_text.Read()
    }
    Set pdf = ##class(Demo.PDFRecord).%New()
    Set pdf.Text = tContent
    Set tSC = pdf.%Save()
    Quit pdf.%Id()
}

/// gets any pdf and vectorized it 
/// @apiPub[params.payload.inputType="application/octet-stream"]
/// @apiPub[response.outputType="application/text"]
/// @apiPub[charset="UTF-8"]
Method SubmitPDF(payload As %Stream.GlobalBinary) As %Stream.GlobalCharacter [ WebMethod ]
{
    Do payload.Rewind()
    Set tContent = ""
    While payload.AtEnd'=1 {
        Set tContent = tContent_payload.Read()
    }
    Set tBase64 = $SYSTEM.Encryption.Base64Encode(tContent)
    Set pdfResponse = ##class(Demo.Utils).GetTextFromPdf(tBase64)
    Set resp = ##class(%Stream.GlobalCharacter).%New()
    Do resp.Write(pdfResponse)

    Set tRequest = ##class(Demo.Operations.Embedding.EmbeddingRequest).%New()
    Set tRequest.Pdf = ..SaveContent(resp)
    Set tSC = ..SendRequestAsync("Embedding Operation", tRequest)

    Quit resp
}

/// Return an array of connections for drawing lines on the config diagram
ClassMethod OnGetConnections(Output pArray As %String, pItem As Ens.Config.Item)
{
    Do ##super(.pArray,pItem)
    If pItem.GetModifiedSetting("TargetConfigName",.tValue) {
        For i=1:1:$LENGTH(tValue,",") { 
            Set tOne=$ZSTRIP($PIECE(tValue,",",i),"<>W")  
            Continue:""=tOne  Set pArray(tOne)="" }
    }
}

}
