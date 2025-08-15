Class Demo.Operations.LlmLocal.APIOperation Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

/// These are the production settings for this object
/// /// Ollama models can be choose on https://Ollama.com/
Parameter SETTINGS = "Model:LLM Local,Host:LLM Local,Port:LLM Local,ChatBotInstructions:LLM Local, NumPredict:LLM Local,TopK:LLM Local,TopP:LLM Local,Temperature:LLM Local";

/// Model used in operation.
Property Model As %String(VALUELIST = ",smollm2:1.7b,llama3.2:3b,phi4-mini:3.8b,gemma3n:e4b,gemma3:4b,qwen3:4b,qwen3:8b,mistral:7b,llama3.1:8b") [ InitialExpression = "llama3.2:3b" ];

Property Host As %String(MAXLEN = 256) [ InitialExpression = "host.docker.internal" ];

Property Port As %String(MAXLEN = 5) [ InitialExpression = "11434" ];

Property ChatBotInstructions As %String(MAXLEN = 1024) [ InitialExpression = "Your task is to answer the user's question using only the information provided in the context. If the context doesn't contain the answer, respond with ""I can't answer this question based on the context provided."" If the answer is present, summarize the relevant information into a clear and concise response. Don't add any information that isn't present in the context or say it is based on context." ];

/// Property ChatBotInstructions As %String(MAXLEN = 1024) [ InitialExpression = "Sua tarefa é responder à pergunta do usuário usando apenas as informações fornecidas no contexto. Se o contexto não contiver a resposta, responda com ""Não posso responder a esta pergunta com base no contexto fornecido"". Se a resposta estiver presente, sintetize as informações relevantes em uma resposta clara e concisa. Não adicione nenhuma informação que não esteja presente no contexto." ];
/// ChatBotInstructions PTBR: Sua tarefa é responder à pergunta do usuário usando apenas as informações fornecidas no contexto. Se o contexto não contiver a resposta, responda com "Não posso responder a esta pergunta com base no contexto fornecido". Se a resposta estiver presente, sintetize as informações relevantes em uma resposta clara e concisa. Não adicione nenhuma informação que não esteja presente no contexto.
/// Maximum number of tokens to predict when generating text. (Default: -1, infinite generation)
Property NumPredict As %Integer [ InitialExpression = 200 ];

/// Reduces the probability of generating nonsense. A higher value (e.g. 100) will give more diverse answers, while a lower value (e.g. 10) will be more conservative. (Default: 40)
Property TopK As %Integer [ InitialExpression = 40 ];

/// Works together with top-k. A higher value (e.g., 0.95) will lead to more diverse text, while a lower value (e.g., 0.5) will generate more focused and conservative text. (Default: 0.9)
Property TopP As %Double [ InitialExpression = 0.7 ];

/// The temperature of the model. Increasing the temperature will make the model answer more creatively. (Default: 0.8)
Property Temperature As %Double [ InitialExpression = 0.3 ];

/// Ollama client instance
Property client As %SYS.Python;

XData MessageMap
{
<MapItems>
  <MapItem MessageType="Demo.GenerateRequest">
    <Method>OnGenerateRequest</Method>
  </MapItem>
</MapItems>
}

Method OnGenerateRequest(pRequest As Demo.GenerateRequest, Output pResponse As Demo.GenerateResponse) As %Status
{
    #dim sc As %Status = $$$OK
    Set pResponse = ##class(Demo.GenerateResponse).%New()
    Try {
        Set pResponse.Model = ..Model
        Set pResponse.Response = ..GenerateRequest(pRequest)
    } Catch ex {
        Set sc = ex.AsStatus()
    }

    Quit sc
}

Method GenerateRequest(pRequest As Demo.GenerateRequest) As %String [ Language = python ]
{
    import json
    from typing import Dict, Any, Callable

    if self.Model not in self.client.list().__str__():
        status = self.client.pull(self.Model)
        self.Trace("Pull Response: " + str(status))


    response = self.client.chat(
        self.Model,
        messages=[{"role": "assistant", "content": self.ChatBotInstructions}, {"role": "user", "content": pRequest.Prompt}],
        stream= False,
        options={
            'temperature': self.Temperature,
            'mirostat': 2,
            'num_predict': self.NumPredict,
            'top_k': self.TopK,
            'top_p': self.TopP
        }
    )
    
    self.Trace("API Response: " + response.__str__())
    
    output = response['message']['content']

    return output
}

Method OnInit() As %Status
{
    #dim sc As %Status = $$$OK
    try {
        do ..PyInit()
    } catch ex {
        set sc = ex.AsStatus()
    }
    quit sc
}

Method PyInit() [ Language = python ]
{
    import ollama
    url = "http://"+self.Host+":"+self.Port
    self.client = ollama.Client(
        host='http://host.docker.internal:11434'
    )
}

ClassMethod LogInfo(Msg As %String)
{
    $$$LOGINFO(Msg)
}

ClassMethod Trace(Msg As %String)
{
    $$$TRACE(Msg)
}

}
