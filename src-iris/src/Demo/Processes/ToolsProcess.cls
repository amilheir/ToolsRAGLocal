/// 
Class Demo.Processes.ToolsProcess Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Demo.GenerateRequest' response='Demo.GenerateResponse' height='2000' width='2000' >
<context>
<property name='ToolsCall' type='Demo.Operations.LlmLocal.Messages.ToolResponse' instantiate='0' deletewithcontext='0' />
<property name='GetStockPrice' type='Demo.Operations.LlmLocal.Messages.ToolResultResponse' instantiate='0' deletewithcontext='0' />
<property name='ToolsPrompt' type='Demo.Operations.LlmLocal.Messages.ToolPromptResponse' instantiate='0' deletewithcontext='0' />
<property name='LLMOperation' type='Demo.GenerateResponse' instantiate='0' deletewithcontext='0' />
<property name='GetSQLInfo' type='Demo.Operations.LlmLocal.Messages.ToolReponseSQL' instantiate='0' deletewithcontext='0' />
<property name='GetSQLQuery' type='Demo.Operations.LlmLocal.Messages.ToolReponseSQL' instantiate='0' deletewithcontext='0' />
<property name='LLMPrompt' type='%String' instantiate='0' deletewithcontext='0' >
<parameters>
<parameter name='MAXLEN'  value='' />
</parameters>
</property>
<property name='RAG' type='Demo.Operations.RAG.RAGResponse' instantiate='0' deletewithcontext='0' />
<property name='RAGPrompt' type='Demo.Operations.Prompt.PromptResponse' instantiate='0' deletewithcontext='0' />
</context>
<sequence xend='200' yend='1000' >
<call name='Tool Call' target='Tools Call' async='0' xpos='200' ypos='250' >
<request type='Demo.Operations.LlmLocal.Messages.ToolRequest' >
<assign property="callrequest.Prompt" value="request.Prompt" action="set" />
</request>
<response type='Demo.Operations.LlmLocal.Messages.ToolResponse' >
<assign property="context.ToolsCall" value="callresponse" action="set" />
</response>
</call>
<switch name='Select Tool' xpos='200' ypos='350' xend='200' yend='800' >
<case condition='context.ToolsCall.ToolName="get_stock_price"' name='get_stock_price' >
<call name='Stock Price' target='Get Stock Price' async='0' xpos='335' ypos='500' >
<request type='Demo.Operations.LlmLocal.Messages.ToolResultRequest' >
<assign property="callrequest.Arguments" value="context.ToolsCall.Arguments" action="set" />
</request>
<response type='Demo.Operations.LlmLocal.Messages.ToolResultResponse' >
<assign property="context.GetStockPrice" value="callresponse" action="set" />
</response>
</call>
<call name='Tool Prompt Text' target='Tools Prompt' async='0' xpos='335' ypos='600' >
<request type='Demo.Operations.LlmLocal.Messages.ToolPromptRequest' >
<assign property="callrequest.Result" value="context.GetStockPrice.Result" action="set" />
<assign property="callrequest.Prompt" value="request.Prompt" action="set" />
</request>
<response type='Demo.Operations.LlmLocal.Messages.ToolPromptResponse' >
<assign property="context.ToolsPrompt" value="callresponse" action="set" />
</response>
</call>
<assign name="Prompt Stock" property="context.LLMPrompt" value="context.ToolsPrompt.Prompt" action="set" xpos='335' ypos='700' />
</case>
<case condition='context.ToolsCall.ToolName="make_query_support_info"' name='make_query_support_info' >
<call name='SQL Info' target='Get SQL Query' async='0' xpos='605' ypos='500' >
<request type='Demo.Operations.LlmLocal.Messages.ToolRequestSQL' >
<assign property="callrequest.Data" value="context.ToolsCall.Arguments" action="set" />
</request>
<response type='Demo.Operations.LlmLocal.Messages.ToolReponseSQL' >
<assign property="context.GetSQLQuery" value="callresponse" action="set" />
</response>
</call>
<call name='Tool Prompt Text 2' target='Tools Prompt' async='0' xpos='605' ypos='600' >
<request type='Demo.Operations.LlmLocal.Messages.ToolPromptRequest' >
<assign property="callrequest.Prompt" value="request.Prompt" action="set" />
<assign property="callrequest.Result" value="context.GetSQLQuery.Result" action="set" />
</request>
<response type='Demo.Operations.LlmLocal.Messages.ToolPromptResponse' >
<assign property="context.ToolsPrompt" value="callresponse" action="set" />
</response>
</call>
<assign name="Prompt SQL" property="context.LLMPrompt" value="context.ToolsPrompt.Prompt" action="set" xpos='605' ypos='700' />
</case>
<case condition='context.ToolsCall.ToolName="retrieve_docs"' name='retrieve_docs' >
<call name='RAG' target='RAG' async='0' xpos='875' ypos='500' >
<request type='Demo.GenerateRequest' >
<assign property="callrequest.Prompt" value="context.ToolsCall.Arguments" action="set" />
</request>
<response type='Demo.Operations.RAG.RAGResponse' >
<assign property="context.RAG.DocIds" value="callresponse.DocIds" action="set" />
<assign property="context.RAG.DocCount" value="callresponse.DocCount" action="set" />
<assign property="context.RAG.Column" value="callresponse.Column" action="set" />
</response>
</call>
<call name='RAG Prompt Text' target='RAG Prompt' async='0' xpos='875' ypos='600' >
<request type='Demo.Operations.Prompt.PromptRequest' >
<assign property="callrequest.DocIds" value="context.RAG.DocIds" action="set" />
<assign property="callrequest.Prompt" value="request.Prompt" action="set" />
<assign property="callrequest.Column" value="context.RAG.Column" action="set" />
</request>
<response type='Demo.Operations.Prompt.PromptResponse' >
<assign property="context.RAGPrompt" value="callresponse" action="set" />
</response>
</call>
<assign name="Prompt RAG" property="context.LLMPrompt" value="context.RAGPrompt.Prompt" action="set" xpos='875' ypos='700' />
</case>
<default/>
</switch>
<call name='LLM Operatio' target='LLM Operation' async='0' xpos='200' ypos='900' >
<request type='Demo.GenerateRequest' >
<assign property="callrequest.Prompt" value="context.LLMPrompt" action="set" />
</request>
<response type='Demo.GenerateResponse' >
<assign property="response.Response" value="callresponse.Response" action="set" />
<assign property="response.Model" value="callresponse.Model" action="set" />
</response>
</call>
</sequence>
</process>
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
