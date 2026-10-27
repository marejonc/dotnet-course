-- Seeds dummy Stocks and Comments. Safe to re-run: wipes both tables first.
BEGIN;

TRUNCATE TABLE "Comments", "Stocks" RESTART IDENTITY CASCADE;

INSERT INTO "Stocks" ("Symbol", "CompanyName", "Purchase", "LastDividend", "Industry", "MarketCap") VALUES
    ('AAPL', 'Apple Inc.',            189.50, 0.24, 'Technology',     2950000000000),
    ('MSFT', 'Microsoft Corporation', 415.20, 0.75, 'Technology',     3080000000000),
    ('TSLA', 'Tesla Inc.',            242.10, 0.00, 'Automotive',      770000000000),
    ('JPM',  'JPMorgan Chase & Co.',  198.30, 1.15, 'Financials',      570000000000),
    ('KO',   'The Coca-Cola Company',  62.40, 0.49, 'Consumer Goods',  270000000000),
    ('PFE',  'Pfizer Inc.',            28.90, 0.42, 'Healthcare',      163000000000),
    ('XOM',  'Exxon Mobil Corp.',     112.75, 0.95, 'Energy',          450000000000),
    ('NVDA', 'NVIDIA Corporation',    875.00, 0.04, 'Semiconductors', 2150000000000);

INSERT INTO "Comments" ("Title", "Content", "CreatedOn", "StockId")
SELECT c.title, c.content, NOW() - c.age, s."Id"
FROM (VALUES
    ('AAPL', 'Strong ecosystem',     'Services revenue keeps growing every quarter.',          INTERVAL '2 days'),
    ('AAPL', 'Pricey valuation',     'Great company, but the P/E looks stretched to me.',      INTERVAL '5 hours'),
    ('MSFT', 'Cloud leader',         'Azure growth is the main reason I hold this.',           INTERVAL '1 day'),
    ('TSLA', 'Volatile ride',        'Buckle up, this one swings 5% on a tweet.',              INTERVAL '3 days'),
    ('TSLA', 'Margins under pressure','Price cuts are eating into automotive margins.',        INTERVAL '12 hours'),
    ('JPM',  'Solid bank',           'Best-run bank in the US, steady dividend.',              INTERVAL '6 days'),
    ('KO',   'Dividend king',        'Boring, reliable, and pays me every quarter.',           INTERVAL '10 days'),
    ('PFE',  'Post-COVID slump',     'Revenue normalizing, waiting for the pipeline to pay off.', INTERVAL '4 days'),
    ('XOM',  'Oil price play',       'Moves with crude, decent yield in the meantime.',        INTERVAL '8 hours'),
    ('NVDA', 'AI darling',           'Data center demand is insane right now.',                INTERVAL '1 hour'),
    ('NVDA', 'Too hot?',             'Might wait for a pullback before adding more.',          INTERVAL '30 minutes')
) AS c(symbol, title, content, age)
JOIN "Stocks" s ON s."Symbol" = c.symbol;

COMMIT;
