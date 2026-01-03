export function score(simulation) {
  let score = 0;

  if (simulation.approvals.length) score += 5;
  if (simulation.nftTransfers.length) score += 5;
  if (simulation.tokenTransfers.length) score += 3;

  if (score > 8) return "HIGH";
  if (score > 4) return "MEDIUM";
  return "LOW";
}
