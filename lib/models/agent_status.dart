enum AgentStatus {
  idle(''),
  thinking('Thinking...'),
  resolvingDate('Figuring out date...'),
  savingMemory('Adding to memory...'),
  fetchingLogs('Getting the logs...'),
  summarizing('Reading through logs...');

  final String label;

  const AgentStatus(this.label);
}
