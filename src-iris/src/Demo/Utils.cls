Class Demo.Utils Extends %RegisteredObject
{

ClassMethod GetChunks(pText As %SYS.Python, pChunkSize As %Integer, pChunkOverlap As %Integer) As %SYS.Python [ Language = python ]
{
    from langchain.text_splitter import RecursiveCharacterTextSplitter

    text_splitter = RecursiveCharacterTextSplitter(
    chunk_size = pChunkSize,
    chunk_overlap  = pChunkOverlap
    )
    docs = text_splitter.split_text(pText)

    return docs
}

ClassMethod GetTextFromPdf(pdfBinary) As %SYS.Python [ Language = python ]
{
    import base64
    from io import BytesIO
    from PyPDF2 import PdfReader
    pdf_bytes = base64.b64decode(pdfBinary)
    reader = PdfReader(BytesIO(pdf_bytes))

    text = ""
    for page in reader.pages:
        text += page.extract_text()

    return text
}

ClassMethod GetTextFromAudio(filepath As %String) As %SYS.Python [ Language = python ]
{
    from faster_whisper import WhisperModel
    import os 
    def transcribe_audio(audio_file) -> str:
        model_size = "medium"
        model = WhisperModel(model_size, device="cuda", compute_type="float16")
        trascript=""      
        if os.path.exists(audio_file):
            segments, info = model.transcribe(audio_file, beam_size=5, vad_filter=True)
            for segment in segments:
                trascript = trascript + segment.text
        return trascript

    text = transcribe_audio(filepath)
    return text
}

ClassMethod GetCleanTxt(text) As %String [ Language = python ]
{
    
    import re
    clean_text = re.sub('\n', ' ', text)  # Remove new lines
    clean_text = re.sub(' +', ' ', clean_text)  # Remove extra spaces
    clean_text = re.sub(r"[^a-zA-Z0-9.,;:?!\/\-% áàãâäéèêëíìîïóòõôöúùûüçÁÀÃÂÄÉÈÊËÍÌÎÏÓÒÕÔÖÚÙÛÜÇ]", "", clean_text)
    return clean_text
}

}
