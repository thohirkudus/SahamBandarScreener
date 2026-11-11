"""
Saham Bandar Screener API Server
FastAPI backend providing screening data for IDX (Indonesian Stock Exchange) stocks
Filtering by Bandarmology Accumulation (Foreign/Broker Flow) and MACD Golden Cross.
"""

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime, timedelta
import random

app = FastAPI(
    title="Saham Bandar & MACD Screener API",
    description="Backend API for IDX Stock Screening combining Bandarmology & MACD Technical Signals",
    version="1.0.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ----------------- Models -----------------

class Candle(BaseModel):
    date: datetime
    open: float
    high: float
    low: float
    close: float
    volume: float
    foreignNetValue: float

class MACDPoint(BaseModel):
    date: datetime
    macd: float
    signal: float
    histogram: float

class TechnicalIndicatorData(BaseModel):
    macdPoints: List[MACDPoint]
    latestMACD: float
    latestSignal: float
    latestHistogram: float
    isGoldenCrossToday: bool
    daysSinceGoldenCross: Optional[int]
    isBelowZeroLine: bool
    rsi14: float
    ma20: float
    ma50: float

class BrokerDetail(BaseModel):
    code: str
    name: str
    netValue: float
    avgPrice: float
    isForeign: bool

class BrokerSummaryData(BaseModel):
    topBuyers: List[BrokerDetail]
    topSellers: List[BrokerDetail]
    cr3: float
    cr5: float
    buyerSellerDiff: float
    dominantBuyerSide: str

class ForeignFlowSummary(BaseModel):
    netForeign1D: float
    netForeign5D: float
    netForeign20D: float
    foreignParticipationRate: float

class BandarmologyData(BaseModel):
    accumulationStatus: str
    foreignFlow: ForeignFlowSummary
    brokerSummary: BrokerSummaryData
    bandarScore: int
    bandarPhase: str
    bandarAvgPrice: float

class Stock(BaseModel):
    ticker: str
    name: str
    sector: str
    currentPrice: float
    previousClose: float
    change: float
    changePercent: float
    dayHigh: float
    dayLow: float
    volumeLot: float
    turnoverIDR: float
    marketCapIDR: float
    bandarmology: BandarmologyData
    technical: TechnicalIndicatorData
    candles: List[Candle]

# ----------------- Mock Data Generator -----------------

def generate_candles(base_price: float, days: int = 45):
    candles = []
    now = datetime.now()
    price = base_price * 0.92
    
    for i in range(days):
        dt = now - timedelta(days=days - 1 - i)
        if i < 28:
            price *= 0.995
        elif i < days - 2:
            price *= 1.002
        elif i == days - 2:
            price *= 1.022
        else:
            price = base_price
            
        high = price * 1.012
        low = price * 0.988
        candles.append(Candle(
            date=dt,
            open=(price + low) / 2.0,
            high=high,
            low=low,
            close=price,
            volume=50_000_000 + random.uniform(-10000000, 10000000),
            foreignNetValue=random.uniform(10_000_000_000, 50_000_000_000)
        ))
    return candles

def compute_macd(candles: List[Candle]):
    points = []
    for c in candles[-20:]:
        points.append(MACDPoint(
            date=c.date,
            macd=random.uniform(5.0, 18.0),
            signal=random.uniform(4.0, 15.0),
            histogram=random.uniform(1.0, 5.0)
        ))
    return points

@app.get("/")
def index():
    return {
        "app": "Saham Bandar & MACD Screener API",
        "status": "Online",
        "docs": "/docs",
        "endpoints": ["/api/screener", "/api/stocks/{ticker}"]
    }

@app.get("/api/screener", response_model=List[Stock])
def get_screener():
    # Return simulated high-probability stocks
    stocks_meta = [
        {"ticker": "BBCA", "name": "Bank Central Asia Tbk", "sector": "Financials", "price": 9850, "foreign1d": 215400000000, "accum": "Big Accumulation"},
        {"ticker": "BBRI", "name": "Bank Rakyat Indonesia Tbk", "sector": "Financials", "price": 4720, "foreign1d": 148900000000, "accum": "Big Accumulation"},
        {"ticker": "TLKM", "name": "Telkom Indonesia Tbk", "sector": "Infrastructure & Telco", "price": 2880, "foreign1d": 64500000000, "accum": "Accumulation"},
        {"ticker": "ASII", "name": "Astra International Tbk", "sector": "Consumer Goods", "price": 5050, "foreign1d": 78200000000, "accum": "Big Accumulation"},
        {"ticker": "AMMN", "name": "Amman Mineral Internasional Tbk", "sector": "Basic Materials", "price": 9200, "foreign1d": 105000000000, "accum": "Big Accumulation"},
        {"ticker": "MEDC", "name": "Medco Energi Internasional Tbk", "sector": "Energy & Mining", "price": 1310, "foreign1d": 24500000000, "accum": "Accumulation"},
        {"ticker": "BRIS", "name": "Bank Syariah Indonesia Tbk", "sector": "Financials", "price": 2940, "foreign1d": 38700000000, "accum": "Big Accumulation"},
    ]
    
    result = []
    for item in stocks_meta:
        candles = generate_candles(item["price"])
        macd_pts = compute_macd(candles)
        
        stock = Stock(
            ticker=item["ticker"],
            name=item["name"],
            sector=item["sector"],
            currentPrice=item["price"],
            previousClose=item["price"] * 0.985,
            change=item["price"] * 0.015,
            changePercent=1.52,
            dayHigh=item["price"] * 1.02,
            dayLow=item["price"] * 0.98,
            volumeLot=650000,
            turnoverIDR=500000000000,
            marketCapIDR=600000000000000,
            bandarmology=BandarmologyData(
                accumulationStatus=item["accum"],
                foreignFlow=ForeignFlowSummary(
                    netForeign1D=item["foreign1d"],
                    netForeign5D=item["foreign1d"] * 3.8,
                    netForeign20D=item["foreign1d"] * 9.2,
                    foreignParticipationRate=0.54
                ),
                brokerSummary=BrokerSummaryData(
                    topBuyers=[
                        BrokerDetail(code="ZP", name="Maybank", netValue=50000000000, avgPrice=item["price"]*0.99, isForeign=True),
                        BrokerDetail(code="AK", name="UBS", netValue=42000000000, avgPrice=item["price"]*0.995, isForeign=True),
                        BrokerDetail(code="BK", name="J.P. Morgan", netValue=35000000000, avgPrice=item["price"]*0.992, isForeign=True)
                    ],
                    topSellers=[
                        BrokerDetail(code="YP", name="Mirae Asset", netValue=-25000000000, avgPrice=item["price"]*0.988, isForeign=False),
                        BrokerDetail(code="PD", name="Indo Premier", netValue=-19000000000, avgPrice=item["price"]*0.99, isForeign=False),
                        BrokerDetail(code="XC", name="Ajaib", netValue=-12000000000, avgPrice=item["price"]*0.989, isForeign=False)
                    ],
                    cr3=0.62,
                    cr5=0.76,
                    buyerSellerDiff=71000000000,
                    dominantBuyerSide="Foreign Institutional Smart Money"
                ),
                bandarScore=92,
                bandarPhase="Akumulasi Masif",
                bandarAvgPrice=item["price"] * 0.992
            ),
            technical=TechnicalIndicatorData(
                macdPoints=macd_pts,
                latestMACD=12.5,
                latestSignal=8.2,
                latestHistogram=4.3,
                isGoldenCrossToday=True,
                daysSinceGoldenCross=0,
                isBelowZeroLine=False,
                rsi14=58.5,
                ma20=item["price"] * 0.98,
                ma50=item["price"] * 0.96
            ),
            candles=candles
        )
        result.append(stock)
    return result

@app.get("/api/stocks/{ticker}", response_model=Stock)
def get_stock_detail(ticker: str):
    screener_list = get_screener()
    for s in screener_list:
        if s.ticker.upper() == ticker.upper():
            return s
    raise HTTPException(status_code=404, detail=f"Stock {ticker} not found in active screener pool")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
