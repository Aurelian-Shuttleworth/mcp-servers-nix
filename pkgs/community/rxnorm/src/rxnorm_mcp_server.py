from typing import Any, Dict, List

import httpx
from mcp.server.fastmcp import FastMCP

# Initialize FastMCP server
mcp = FastMCP("rxnorm")

RXNORM_API_BASE = "https://rxnav.nlm.nih.gov/REST"


async def get_rxcui(drug_name: str) -> str | None:
    """Helper to get RxCUI for a single drug name."""
    async with httpx.AsyncClient() as client:
        try:
            response = await client.get(
                f"{RXNORM_API_BASE}/rxcui.json", params={"name": drug_name}
            )
            data = response.json()
            id_group = data.get("idGroup", {})
            rxnorm_ids = id_group.get("rxnormId")
            if rxnorm_ids and len(rxnorm_ids) > 0:
                return rxnorm_ids[0]
            return None
        except Exception as e:
            print(f"Error fetching RxCUI for {drug_name}: {e}")
            return None


@mcp.tool()
async def find_drug_rxcui(drug_name: str) -> str:
    """
    Search for the RxNorm Concept Unique Identifier (RxCUI) for a given drug name.

    Args:
        drug_name: The name of the drug (e.g., 'Ibuprofen', 'Tylenol')

    Returns:
        The RxCUI string if found, or a message indicating not found.
    """
    rxcui = await get_rxcui(drug_name)
    if rxcui:
        return f"RxCUI for '{drug_name}': {rxcui}"
    else:
        return f"No RxCUI found for '{drug_name}'"


def main():
    mcp.run()


if __name__ == "__main__":
    main()
