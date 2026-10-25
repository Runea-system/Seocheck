# Moondeng (MOODENG) — BNB Smart Chain

Contract: 0x2b110eDf44534E063fCE1805b092FfacC0DF13F5 (Chain ID 56)
Supply: 2,222 · freeMint 0.0002 BNB · mintTier 1–4: 0.001 / 0.002 / 0.003 / 0.004 BNB · max 5 per wallet

## Struktur
- images/ — 50 artwork hippo (dipakai bergilir untuk 2,222 token)
- metadata/1.json … 2222.json — metadata tiap token
- contract/Moondeng.sol — source kontrak yang di-deploy

## Setelah upload ke repo Runea-system/Seocheck (branch main)
Dari wallet owner, panggil di kontrak:
1. setBaseURI("https://raw.githubusercontent.com/Runea-system/Seocheck/main/metadata/")
2. setMintOpen(true)
