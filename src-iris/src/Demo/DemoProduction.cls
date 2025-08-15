Class Demo.DemoProduction Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="Demo.DemoProduction" TestingEnabled="true" LogGeneralTraceEvents="true">
  <Description></Description>
  <ActorPoolSize>1</ActorPoolSize>
  <Item Name="Embedding Operation" Category="" ClassName="Demo.Operations.Embedding.EmbeddingOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="ChunkOverlap">51</Setting>
    <Setting Target="Host" Name="ChunkSize">512</Setting>
    <Setting Target="Host" Name="FailureTimeout">-1</Setting>
  </Item>
  <Item Name="RAG Operation" Category="" ClassName="Demo.Operations.RAG.RAGOperation" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="FailureTimeout">-1</Setting>
    <Setting Target="Host" Name="NumberOfRetrivals">5</Setting>
  </Item>
  <Item Name="Injection Process" Category="" ClassName="Demo.Processes.InjectionProcess" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Prompt Operation" Category="" ClassName="Demo.Operations.Prompt.PromptOperation" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Streamlit Service" Category="" ClassName="Demo.Service.StreamlitService" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigName">Tools Process</Setting>
  </Item>
  <Item Name="Start Audio Import" Category="" ClassName="Demo.Service.CheckAudioFile" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="ArchivePath">/iris-shared/Archieve/</Setting>
    <Setting Target="Adapter" Name="FilePath">/iris-shared/Input/</Setting>
  </Item>
  <Item Name="LLM Operation" Category="" ClassName="Demo.Operations.LlmLocal.APIOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="Model">mistral:7b</Setting>
    <Setting Target="Host" Name="ChatBotInstructions">Você é um assistente útil que responde a perguntas. Sua tarefa é responder à pergunta do usuário usando apenas as informações fornecidas no contexto, conforme seu conhecimento. Se o contexto não contiver a resposta, responda com "Não posso responder a esta pergunta, não tenho informações sobre ela". Se a resposta estiver presente, resuma as informações relevantes em uma resposta clara e concisa. Não adicione nenhuma informação que não esteja presente no contexto.</Setting>
    <Setting Target="Host" Name="NumPredict">400</Setting>
    <Setting Target="Host" Name="TopK">40</Setting>
    <Setting Target="Host" Name="TopP">0.7</Setting>
    <Setting Target="Host" Name="Temperature">0.1</Setting>
    <Setting Target="Host" Name="Port">11434</Setting>
    <Setting Target="Host" Name="FailureTimeout">60</Setting>
  </Item>
  <Item Name="LLM Process Local" Category="" ClassName="Demo.Processes.LLMProcessLocal" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Tools Call" Category="" ClassName="Demo.Operations.LlmLocal.ToolsCall" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Get Stock Price" Category="" ClassName="Demo.Operations.LlmLocal.ToolGetStockPrice" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Tools Prompt" Category="" ClassName="Demo.Operations.LlmLocal.ToolPrompt" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Tools Process" Category="" ClassName="Demo.Processes.ToolsProcess" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Get SQL Query" Category="" ClassName="Demo.Operations.LlmLocal.ToolGetSqlQuery" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="RAG" Category="" ClassName="Demo.Operations.LlmLocal.ToolRAG" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="NumberOfRetrivals">3</Setting>
  </Item>
  <Item Name="RAG Prompt" Category="" ClassName="Demo.Operations.LlmLocal.ToolRAGPrompt" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
</Production>
}

}
