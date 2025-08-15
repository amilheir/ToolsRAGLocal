Class Demo.Operations.LlmLocal.ToolsCall Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

/// These are the production settings for this object
/// /// Ollama models can be choose on https://Ollama.com/
Parameter SETTINGS = "Model:LLM Local,Host:LLM Local,Port:LLM Local,ChatBotInstructions:LLM Local, NumPredict:LLM Local,TopK:LLM Local,TopP:LLM Local,Temperature:LLM Local";

/// Model used in operation.
Property Model As %String(VALUELIST = ",smollm2:1.7b,llama3.2:3b,phi4-mini:3.8b,qwen3:4b,qwen3:8b,mistral:7b,llama3.1:8b") [ InitialExpression = "llama3.2:3b" ];

Property Host As %String(MAXLEN = 256) [ InitialExpression = "host.docker.internal" ];

Property Port As %String(MAXLEN = 5) [ InitialExpression = "11434" ];

Property ChatBotInstructions As %String(MAXLEN = 1024) [ InitialExpression = "You are an assistant that have access to a set of tools to use. Just pass the information in human format." ];

/// ChatBotInstructions PTBR: Sua tarefa é responder à pergunta do usuário usando apenas as informações fornecidas no contexto. Se o contexto não contiver a resposta, responda com "Não posso responder a esta pergunta com base no contexto fornecido". Se a resposta estiver presente, sintetize as informações relevantes em uma resposta clara e concisa. Não adicione nenhuma informação que não esteja presente no contexto.
/// Maximum number of tokens to predict when generating text. (Default: -1, infinite generation)
Property NumPredict As %Integer [ InitialExpression = 200 ];

/// Reduces the probability of generating nonsense. A higher value (e.g. 100) will give more diverse answers, while a lower value (e.g. 10) will be more conservative. (Default: 40)
Property TopK As %Integer [ InitialExpression = 40 ];

/// Works together with top-k. A higher value (e.g., 0.95) will lead to more diverse text, while a lower value (e.g., 0.5) will generate more focused and conservative text. (Default: 0.9)
Property TopP As %Double [ InitialExpression = 0.7 ];

/// The temperature of the model. Increasing the temperature will make the model answer more creatively. (Default: 0.8)
Property Temperature As %Double [ InitialExpression = 0.3 ];

XData MessageMap
{
<MapItems>
  <MapItem MessageType="Demo.Operations.LlmLocal.Messages.ToolRequest">
    <Method>OnGenerateRequest</Method>
  </MapItem>
</MapItems>
}

Method OnGenerateRequest(pRequest As Demo.Operations.LlmLocal.Messages.ToolRequest, Output pResponse As Demo.Operations.LlmLocal.Messages.ToolResponse) As %Status
{
    #dim sc As %Status = $$$OK
    Set pResponse = ##class(Demo.Operations.LlmLocal.Messages.ToolResponse).%New()
    Try {
        Set pResponse.Model = ..Model
        Set pResponse.ToolName = ..GenerateRequest(pRequest).ToolName
        Set pResponse.Arguments = ..GenerateRequest(pRequest).Arguments
    } Catch ex {
        Set sc = ex.AsStatus()
    }

    Quit sc
}

Method GenerateRequest(pRequest As Demo.Operations.LlmLocal.Messages.ToolRequest) As %String [ Language = python ]
{
    import ollama
    import json
    import ast
    from typing import Dict, Any, Callable
    
    class Output:
        def __init__(self, ToolName, Arguments):
            self.ToolName = ToolName
            self.Arguments = Arguments
    
    get_stock_price_tool = {
        'type': 'function',
        'function': {
            'name': 'get_stock_price',
            'description': 'Get the up-to-date or accurate stock price for any symbol',
            'parameters': {
                'type': 'object',
                'required': ['symbol'],
                'properties': {
                    'symbol': {'type': 'string', 'description': 'The stock symbol (e.g., AAPL, GOOGL)'},
                },
            },
        },
    }

    retrieve_docs_tool = {
        "type": "function",
        "function": {
            "name": "retrieve_docs",
            "description": "Retrieve relevant information from documents, stored in a vector database, about support tickets as: description, resolution details, internal notes.",
            "parameters": {
                "type": "object",
                "properties": {
                    "query": {"type": "string", "description": "A search query to find relevant information in the documents."},
                    "column_name": {"type": "string", "description": "Suport tickets  have three columns: 'DescriptionEmb', 'ResolutionDetailsEmb', 'InternalNotesEmb'. You can use one of these columns to retrieve the information."},
                },
                "required": ["query", "column_name"],
            }
        }
    }

    make_query_support_info_tool = {
        "type": "function",
        "function": {
            "name": "make_query_support_info",
            "description": "select information of a sql table of support tickets in the database, , you can use filters (e.g., WHERE, DISTINCT, COUNT).",
            "parameters": {
                "type": "object",
                "properties": {
                    "query": {"type": "SQL SELECT QUERY", "description": "Generate a select sql query to get the necessary information of the table 'Demo.SupportTickets', that is has the following columns (TicketId, CrmCustomerId, OpeningDate, ClosingDate, Status, Priority, Channel, AssignedAgentId, ProductServiceInvolved, TicketCategory, Subject, ResolutionDetails, SlaBreached, SatisfactionScore, CustomerFeedback), select only the necessary columns and do not use * ."},
                },
                "required": ["query"]
            }
        }
    }

    url = "http://"+self.Host+":"+self.Port
    
    client = ollama.Client(
            host='http://host.docker.internal:11434'
        )

    if self.Model not in client.list().__str__():
        status = client.pull(model)
        self.Trace("Pull Response: " + str(status))

    response = client.chat(
        self.Model,
        messages=[{"role": "assistant", "content": self.ChatBotInstructions}, {"role": "user", "content": pRequest.Prompt}],
        stream= False,
        tools=[get_stock_price_tool, retrieve_docs_tool, make_query_support_info_tool],
        options={
            'temperature': self.Temperature,
            'mirostat': 2,
            'num_predict': self.NumPredict,
            'top_k': self.TopK,
            'top_p': self.TopP
        }
    )
    
    self.Trace("API Response: " + response.__str__())

    output = Output('', '')

    if response.message.tool_calls:
        # There may be multiple tool calls in the response
        for tool in response.message.tool_calls:
            output.ToolName = str(tool.function.name)
            output.Arguments = json.dumps(ast.literal_eval(str(tool.function.arguments) + " , " + str(output.Arguments)))
        
        return output
    else:
        return self.Trace('No Functions Called')
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
