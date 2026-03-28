enum AgentStatus {
  idle(''),
  thinking('Thinking...'),
  resolvingDate('Figuring out date...'),
  savingMemory('Adding to memory...');

  final String label;

  const AgentStatus(this.label);
}
