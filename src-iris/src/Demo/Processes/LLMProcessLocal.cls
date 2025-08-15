/// 
Class Demo.Processes.LLMProcessLocal Extends Ens.BusinessProcessBPL
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Demo.GenerateRequest' response='Demo.GenerateResponse' height='2000' width='2000' >
<context>
<property name='RAGOperation' type='Demo.Operations.RAG.RAGResponse' instantiate='0' deletewithcontext='0' />
<property name='PromptOperation' type='Demo.Operations.Prompt.PromptResponse' instantiate='0' deletewithcontext='0' />
</context>
<sequence xend='200' yend='550' >
<call name='Call RAG Operation' target='RAG Operation' async='0' xpos='188' ypos='241' >
<request type='Demo.GenerateRequest' >
<assign property="callrequest.Prompt" value="request.Prompt" action="set" />
</request>
<response type='Demo.Operations.RAG.RAGResponse' >
<assign property="context.RAGOperation" value="callresponse" action="set" />
</response>
</call>
<call name='Call Prompt Operation' target='Prompt Operation' async='0' xpos='200' ypos='350' >
<request type='Demo.Operations.Prompt.PromptRequest' >
<assign property="callrequest.Prompt" value="request.Prompt" action="set" />
<assign property="callrequest.DocIds" value="context.RAGOperation.DocIds" action="set" />
</request>
<response type='Demo.Operations.Prompt.PromptResponse' >
<assign property="context.PromptOperation" value="callresponse" action="set" />
</response>
</call>
<call name='Call LLM Operation' target='LLM Operation' async='0' xpos='200' ypos='450' >
<request type='Demo.GenerateRequest' >
<assign property="callrequest.Prompt" value="context.PromptOperation.Prompt" action="set" />
</request>
<response type='Demo.GenerateResponse' >
<assign property="response.Response" value="callresponse.Response" action="set" />
<assign property="response.Model" value="callresponse.Model" action="set" />
</response>
</call>
</sequence>
</process>
}

}
