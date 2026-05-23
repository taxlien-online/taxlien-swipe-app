// common.jsx — shared atoms + property seed data for Tax Lien Galaxy mocks.
// Exposed via window.* for cross-script use under Babel.

const COLORS = {
  brand:   "#005BEA",
  cyan:    "#00C6FB",
  bg:      "#F8F9FA",
  surface: "#FFFFFF",
  fg1:     "#303F49",
  fg2:     "#B6B6B6",
  line:    "rgba(156,178,194,0.10)",
  success: "#1FB67A",
  warning: "#FFB020",
  danger:  "#E5484D",
  purple:  "#7B5BEA",
  // Stage
  stagePre:    "#FFB020",
  stageListed: "#005BEA",
  stageOtc:    "#00C6FB",
  stageSold:   "#B6B6B6",
};

// Format helpers
const usd = (n) => "$" + (n >= 1000 ? Math.round(n/100)/10 + "k" : n.toString());
const usdFull = (n) => "$" + n.toLocaleString();
const pct = (n) => (n*100).toFixed(1).replace(/\.0$/,"") + "%";

// ─────────────────────────────────────────────────────────────
// Deterministic pseudo-random (mulberry32) so layouts don't shimmer.
// ─────────────────────────────────────────────────────────────
function seeded(seed) {
  let s = seed >>> 0;
  return () => {
    s |= 0; s = s + 0x6D2B79F5 | 0;
    let t = Math.imul(s ^ s >>> 15, 1 | s);
    t = t + Math.imul(t ^ t >>> 7, 61 | t) ^ t;
    return ((t ^ t >>> 14) >>> 0) / 4294967296;
  };
}

// ─────────────────────────────────────────────────────────────
// Property seed: 80 properties with all the fields the mechanics need.
// ─────────────────────────────────────────────────────────────
const COUNTIES = [
  { name: "Maricopa",   state: "AZ", weight: 0.18 },
  { name: "Pima",       state: "AZ", weight: 0.08 },
  { name: "Duval",      state: "FL", weight: 0.16 },
  { name: "Orange",     state: "FL", weight: 0.13 },
  { name: "Miami-Dade", state: "FL", weight: 0.11 },
  { name: "Cook",       state: "IL", weight: 0.09 },
  { name: "Harris",     state: "TX", weight: 0.10 },
  { name: "Bexar",      state: "TX", weight: 0.07 },
  { name: "Wayne",      state: "MI", weight: 0.04 },
  { name: "Cuyahoga",   state: "OH", weight: 0.04 },
];

const STREETS = [
  "Oak St","Pine Ave","Elm Rd","Maple Dr","Cedar Ln","Birch Way",
  "Magnolia Blvd","Sunset Ct","Hilltop Dr","Lakeshore Rd","Palm Ave","Sycamore St",
];

const STAGES = ["pre-auction","listed","otc","sold"];
const TYPES  = ["Residential","Vacant Land","Commercial","Agricultural"];

function buildProperties() {
  const r = seeded(7);
  const out = [];
  for (let i = 0; i < 80; i++) {
    const cIdx = Math.floor(r() * COUNTIES.length);
    const c = COUNTIES[cIdx];
    const stage = STAGES[Math.floor(r() * 4)];
    const tIdx = Math.floor(r() * 4);
    const type = TYPES[tIdx];
    const value = Math.round((8000 + r()*250000) / 500) * 500;
    const tax   = Math.round(value * (0.02 + r()*0.06));
    const roi   = +(0.04 + r() * 0.24).toFixed(3); // 4-28%
    const risk  = Math.round(15 + r()*80);
    const redemp = +(0.25 + r()*0.7).toFixed(2);
    const priorY = Math.floor(r()*5);
    const payback = Math.floor(3 + r()*22);
    const intRate = +(0.06 + r()*0.14).toFixed(2);
    const fvi = +(3 + r()*7).toFixed(1);
    const flood = r() < 0.15 ? "AE" : "Zone X";
    const homestead = r() < 0.32;
    const veteran   = r() < 0.08;
    const senior    = r() < 0.14;
    const disability = r() < 0.05;
    const noHeirs   = r() < 0.06;
    const sqft = Math.round(700 + r()*2400);
    const yr = 1940 + Math.floor(r()*82);
    const beds = 1 + Math.floor(r()*5);
    const baths = 1 + Math.floor(r()*4);
    const walk = Math.round(20 + r()*75);
    const school = +(3 + r()*7).toFixed(1);
    const newListing = r() < 0.12;
    const stale = r() < 0.08;
    const auctionDays = Math.floor(r()*120) - 30;

    out.push({
      id: "p" + i,
      address: `${100 + Math.floor(r()*9000)} ${STREETS[Math.floor(r()*STREETS.length)]}`,
      city: c.state === "AZ" ? (r()<0.6?"Phoenix":"Tucson") : c.state === "FL" ? (r()<0.5?"Jacksonville":"Orlando") : c.name,
      county: c.name, state: c.state,
      parcel: `${cIdx}${String(i).padStart(2,"0")}-${Math.floor(r()*900)+100}-${Math.floor(r()*9000)+1000}`,
      type, stage, value, tax, roi, risk, redemp, priorY, payback, intRate, fvi,
      flood, homestead, veteran, senior, disability, noHeirs, sqft, yr, beds, baths,
      walk, school, newListing, stale, auctionDays,
      lat: 25 + r()*20, lng: -120 + r()*60,
    });
  }
  return out;
}

const PROPERTIES = buildProperties();

// ─────────────────────────────────────────────────────────────
// Atoms
// ─────────────────────────────────────────────────────────────
function TopBar({ title, sub, leading, trailing, theme = "light" }) {
  return (
    <div className="topbar">
      <div style={{ display: "flex", alignItems: "center", gap: 8 }}>
        {leading || (
          <button className="icon-btn" aria-label="menu" style={{ marginRight: 6 }}>
            <svg width="16" height="12" viewBox="0 0 16 12" fill="none">
              <path d="M1 1h14M1 6h14M1 11h10" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round"/>
            </svg>
          </button>
        )}
        <div>
          <div className="topbar__title">{title}</div>
          {sub && <div className="topbar__sub">{sub}</div>}
        </div>
      </div>
      <div className="topbar__icons">{trailing}</div>
    </div>
  );
}

function IconButton({ children, label, accent }) {
  return (
    <button className="icon-btn" aria-label={label}
            style={accent ? { background: "var(--brand-gradient)", color: "#fff", boxShadow: "0 6px 16px rgba(0,91,234,0.25)" } : {}}>
      {children}
    </button>
  );
}

// SVG icon library — single-path, currentColor, ~16px viewport
const Ico = {
  search: <svg viewBox="0 0 16 16" width="16" height="16" fill="none"><circle cx="7" cy="7" r="5" stroke="currentColor" strokeWidth="1.6"/><path d="m11 11 3 3" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round"/></svg>,
  ai:     <svg viewBox="0 0 16 16" width="16" height="16" fill="none"><path d="M8 2v3M8 11v3M2 8h3M11 8h3M4 4l2 2M10 10l2 2M4 12l2-2M10 6l2-2" stroke="currentColor" strokeWidth="1.4" strokeLinecap="round"/><circle cx="8" cy="8" r="2.2" fill="currentColor"/></svg>,
  mic:    <svg viewBox="0 0 16 16" width="16" height="16" fill="none"><rect x="5.5" y="1.5" width="5" height="8" rx="2.5" stroke="currentColor" strokeWidth="1.5"/><path d="M3 8a5 5 0 0 0 10 0M8 13v2" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round"/></svg>,
  xray:   <svg viewBox="0 0 16 16" width="16" height="16" fill="none"><circle cx="8" cy="8" r="6" stroke="currentColor" strokeWidth="1.5"/><path d="M5 5l6 6M11 5l-6 6" stroke="currentColor" strokeWidth="1.4" strokeLinecap="round"/></svg>,
  more:   <svg viewBox="0 0 16 16" width="16" height="16" fill="currentColor"><circle cx="3.2" cy="8" r="1.5"/><circle cx="8" cy="8" r="1.5"/><circle cx="12.8" cy="8" r="1.5"/></svg>,
  filter: <svg viewBox="0 0 16 16" width="16" height="16" fill="none"><path d="M2 4h12M4 8h8M6 12h4" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round"/></svg>,
  back:   <svg viewBox="0 0 16 16" width="16" height="16" fill="none"><path d="m10 3-5 5 5 5" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round"/></svg>,
  close:  <svg viewBox="0 0 16 16" width="16" height="16" fill="none"><path d="m3.5 3.5 9 9M12.5 3.5l-9 9" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round"/></svg>,
  plus:   <svg viewBox="0 0 16 16" width="16" height="16" fill="none"><path d="M8 3v10M3 8h10" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round"/></svg>,
  star:   <svg viewBox="0 0 16 16" width="16" height="16" fill="currentColor"><path d="m8 1.6 1.95 4 4.4.64-3.18 3.1.75 4.38L8 11.65l-3.93 2.07.75-4.38L1.65 6.24l4.4-.64z"/></svg>,
  starO:  <svg viewBox="0 0 16 16" width="16" height="16" fill="none" stroke="currentColor" strokeWidth="1.4" strokeLinejoin="round"><path d="m8 1.6 1.95 4 4.4.64-3.18 3.1.75 4.38L8 11.65l-3.93 2.07.75-4.38L1.65 6.24l4.4-.64z"/></svg>,
  bolt:   <svg viewBox="0 0 16 16" width="16" height="16" fill="currentColor"><path d="M9 1 3 9h4l-1 6 6-8H8z"/></svg>,
  warn:   <svg viewBox="0 0 16 16" width="16" height="16" fill="none"><path d="m8 2 6.5 11.5h-13L8 2z" stroke="currentColor" strokeWidth="1.5" strokeLinejoin="round"/><path d="M8 6.5v3M8 11.5v.5" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round"/></svg>,
  shield: <svg viewBox="0 0 16 16" width="16" height="16" fill="none"><path d="M8 1.5 2.5 3.5v4c0 3.5 2.5 6 5.5 7 3-1 5.5-3.5 5.5-7v-4L8 1.5z" stroke="currentColor" strokeWidth="1.5" strokeLinejoin="round"/></svg>,
  trend:  <svg viewBox="0 0 16 16" width="16" height="16" fill="none"><path d="M2 12l4-4 3 2 5-6M10 4h3v3" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round"/></svg>,
  cal:    <svg viewBox="0 0 16 16" width="16" height="16" fill="none"><rect x="2" y="3.5" width="12" height="11" rx="1.5" stroke="currentColor" strokeWidth="1.5"/><path d="M2 6.5h12M5.5 1.5v3M10.5 1.5v3" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round"/></svg>,
  map:    <svg viewBox="0 0 16 16" width="16" height="16" fill="none"><path d="M1.5 4l4-1.5L10 4l4.5-1.5v10L10 14l-4.5-1.5L1.5 14V4zM5.5 2.5v10M10 4v10" stroke="currentColor" strokeWidth="1.5" strokeLinejoin="round"/></svg>,
  layers: <svg viewBox="0 0 16 16" width="16" height="16" fill="none"><path d="m8 1.5 6.5 3.5L8 8.5 1.5 5 8 1.5zM2 8l6 3 6-3M2 11l6 3 6-3" stroke="currentColor" strokeWidth="1.4" strokeLinejoin="round"/></svg>,
  home:   <svg viewBox="0 0 16 16" width="16" height="16" fill="none"><path d="M2 7.5 8 2l6 5.5V14H2V7.5zM6 14V9.5h4V14" stroke="currentColor" strokeWidth="1.5" strokeLinejoin="round"/></svg>,
  list:   <svg viewBox="0 0 16 16" width="16" height="16" fill="none"><path d="M3 4h10M3 8h10M3 12h10" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round"/></svg>,
  heart:  <svg viewBox="0 0 16 16" width="16" height="16" fill="none"><path d="M8 13.5S2 10 2 5.8a3 3 0 0 1 5.5-1.7 3 3 0 0 1 6 1.5C13.5 9 8 13.5 8 13.5z" stroke="currentColor" strokeWidth="1.5" strokeLinejoin="round"/></svg>,
  heartF: <svg viewBox="0 0 16 16" width="16" height="16" fill="currentColor"><path d="M8 13.8S1.5 10.2 1.5 5.8a3.3 3.3 0 0 1 6.5-.9 3.3 3.3 0 0 1 6.5.9C14.5 10.2 8 13.8 8 13.8z"/></svg>,
  user:   <svg viewBox="0 0 16 16" width="16" height="16" fill="none"><circle cx="8" cy="5.5" r="2.6" stroke="currentColor" strokeWidth="1.5"/><path d="M2.5 14c1-2.7 3.2-4 5.5-4s4.5 1.3 5.5 4" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round"/></svg>,
  galaxy: <svg viewBox="0 0 16 16" width="16" height="16" fill="none" stroke="currentColor" strokeWidth="1.4"><ellipse cx="8" cy="8" rx="6.5" ry="2.5" transform="rotate(-25 8 8)"/><circle cx="8" cy="8" r="1.3" fill="currentColor"/></svg>,
  drop:   <svg viewBox="0 0 16 16" width="16" height="16" fill="currentColor"><path d="M8 1.5C8 1.5 3 7 3 10a5 5 0 0 0 10 0C13 7 8 1.5 8 1.5z"/></svg>,
  clock:  <svg viewBox="0 0 16 16" width="16" height="16" fill="none"><circle cx="8" cy="8" r="6" stroke="currentColor" strokeWidth="1.5"/><path d="M8 4.5V8l2.5 1.5" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round"/></svg>,
  sparkle:<svg viewBox="0 0 16 16" width="16" height="16" fill="currentColor"><path d="M8 1l1 4 4 1-4 1-1 4-1-4-4-1 4-1zM13.5 9.5l.5 1.5 1.5.5-1.5.5-.5 1.5-.5-1.5-1.5-.5 1.5-.5z"/></svg>,
  refresh:<svg viewBox="0 0 16 16" width="16" height="16" fill="none"><path d="M2 8a6 6 0 0 1 10.5-4M14 8a6 6 0 0 1-10.5 4M11 1.5v3h3M5 14.5v-3H2" stroke="currentColor" strokeWidth="1.4" strokeLinecap="round" strokeLinejoin="round"/></svg>,
  flag:   <svg viewBox="0 0 16 16" width="16" height="16" fill="none"><path d="M3 14V2.5h8L9.5 5l1.5 2.5H3" stroke="currentColor" strokeWidth="1.5" strokeLinejoin="round"/></svg>,
  play:   <svg viewBox="0 0 16 16" width="16" height="16" fill="currentColor"><path d="M4 2.5 13 8l-9 5.5z"/></svg>,
  pause:  <svg viewBox="0 0 16 16" width="16" height="16" fill="currentColor"><rect x="4" y="3" width="3" height="10" rx="1"/><rect x="9" y="3" width="3" height="10" rx="1"/></svg>,
  reset:  <svg viewBox="0 0 16 16" width="16" height="16" fill="none"><path d="M14 8a6 6 0 1 1-2-4.5M14 1.5v3h-3" stroke="currentColor" strokeWidth="1.4" strokeLinecap="round" strokeLinejoin="round"/></svg>,
  link:   <svg viewBox="0 0 16 16" width="16" height="16" fill="none"><path d="M7 9.5 9.5 7M5.5 11l-1 1a2.5 2.5 0 1 1-3.5-3.5l1-1M10.5 5l1-1a2.5 2.5 0 1 1 3.5 3.5l-1 1" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round"/></svg>,
  vacant: <svg viewBox="0 0 16 16" width="16" height="16" fill="none"><path d="M2 13h12M3.5 13V8L8 4l4.5 4v5M6.5 13v-3h3v3" stroke="currentColor" strokeWidth="1.5" strokeLinejoin="round" strokeDasharray="2 1.5"/></svg>,
  ranch:  <svg viewBox="0 0 16 16" width="16" height="16" fill="none"><path d="M2 13h12M3 13V7l5-3 5 3v6M6 13v-2.5h4V13" stroke="currentColor" strokeWidth="1.5" strokeLinejoin="round"/></svg>,
  scale:  <svg viewBox="0 0 16 16" width="16" height="16" fill="none"><path d="M4 3.5h8M8 3.5v10M5 13.5h6M3 8l1.5-4L6 8a1.5 1.5 0 0 1-3 0zM10 8l1.5-4L13 8a1.5 1.5 0 0 1-3 0z" stroke="currentColor" strokeWidth="1.4" strokeLinecap="round" strokeLinejoin="round"/></svg>,
};

// Bottom navigation bar (4 tabs)
function BottomNav({ active = "galaxy" }) {
  const tabs = [
    { id: "galaxy",    label: "Galaxy",    icon: Ico.galaxy },
    { id: "list",      label: "List",      icon: Ico.list },
    { id: "watchlist", label: "Watchlist", icon: Ico.heart },
    { id: "profile",   label: "Profile",   icon: Ico.user },
  ];
  return (
    <div className="tabbar">
      {tabs.map(t => (
        <div key={t.id} className={"tabbar__btn " + (active === t.id ? "is-active" : "")}>
          <span style={{ color: active === t.id ? "var(--brand-blue)" : "var(--fg-2)" }}>{t.icon}</span>
          <span>{t.label}</span>
        </div>
      ))}
    </div>
  );
}

// Stat tile (used in card details, dashboards)
function StatTile({ label, value, sub, accent }) {
  return (
    <div className="stile">
      <div className="stile__label">{label}</div>
      <div className="stile__value" style={accent ? { color: accent } : null}>{value}</div>
      {sub && <div className="stile__delta" style={{ color: accent || "var(--fg-2)" }}>{sub}</div>}
    </div>
  );
}

// Badge / chip
function Badge({ tone = "neutral", children, icon }) {
  return <span className={"badge badge--" + tone}>{icon}{children}</span>;
}

// Dot in galaxy
function GalaxyDot({ x, y, size = 12, color = COLORS.brand, ring, halo, label, opacity = 1, style }) {
  const inner = ring ? null : (
    <div style={{
      width: size, height: size, borderRadius: "50%", background: color, opacity,
      boxShadow: halo ? `0 0 0 ${Math.max(size*0.35,3)}px ${color}1e` : "none",
    }}/>
  );
  return (
    <div className="gdot" style={{ left: `${x}%`, top: `${y}%`, color, ...style }}>
      {ring ? (
        <div style={{
          width: size, height: size, borderRadius: "50%",
          border: `2px solid ${color}`, background: "rgba(255,255,255,0.7)", opacity,
        }}/>
      ) : inner}
      {label && (
        <div style={{
          position: "absolute", top: size/2 + 4, left: "50%", transform: "translateX(-50%)",
          fontSize: 9, fontWeight: 600, color: "var(--fg-1)",
          background: "rgba(255,255,255,0.9)", padding: "1px 5px", borderRadius: 4,
          whiteSpace: "nowrap",
        }}>{label}</div>
      )}
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// Galaxy layout calculators (one per dimension)
// Returns array of { id, x, y, size, color, ...flags } in percent units.
// ─────────────────────────────────────────────────────────────
function radiusFromValue(v) {
  // 8..28 px proportional to log value
  const t = Math.min(1, Math.log10(v / 5000) / Math.log10(300000 / 5000));
  return 8 + Math.max(0, t) * 18;
}

function colorByROI(roi) {
  if (roi >= 0.18) return COLORS.success;
  if (roi >= 0.10) return COLORS.warning;
  return COLORS.danger;
}
function colorByRisk(r) {
  if (r <= 35) return COLORS.success;
  if (r <= 65) return COLORS.warning;
  return COLORS.danger;
}
function colorByStage(s) {
  return { "pre-auction": COLORS.warning, listed: COLORS.brand, otc: COLORS.cyan, sold: COLORS.fg2 }[s];
}

function layoutFor(dim) {
  // Use deterministic jitter from id
  const jit = (id, seed) => {
    let h = 0;
    for (let i = 0; i < id.length; i++) h = (h*31 + id.charCodeAt(i) + seed) | 0;
    return ((h & 0xfff) / 4095);
  };

  const W = 8, H = 8;     // margin %
  const range = 100 - 2*W;

  return PROPERTIES.map((p) => {
    let x, y, color, size = radiusFromValue(p.value);
    switch (dim) {
      case "roi": {
        x = W + Math.min(1, p.roi / 0.30) * range;
        const valNorm = Math.min(1, Math.log10(Math.max(p.value, 5000)/5000)/Math.log10(60));
        y = H + (1 - valNorm) * range;
        color = colorByROI(p.roi);
        break;
      }
      case "risk": {
        x = W + (p.risk/100) * range;
        y = H + (1 - p.redemp) * range;
        color = colorByRisk(p.risk);
        break;
      }
      case "stage": {
        const idx = STAGES.indexOf(p.stage);
        x = W + (idx + 0.5) / 4 * range + (jit(p.id, 1) - 0.5) * 14;
        y = H + jit(p.id, 7) * range;
        color = colorByStage(p.stage);
        break;
      }
      case "county": {
        const cIdx = COUNTIES.findIndex(c => c.name === p.county);
        const col = cIdx % 4, row = Math.floor(cIdx / 4);
        const baseX = W + (col + 0.5) / 4 * range;
        const baseY = H + (row + 0.5) / 3 * range;
        x = baseX + (jit(p.id, 3) - 0.5) * 18;
        y = baseY + (jit(p.id, 11) - 0.5) * 22;
        color = colorByROI(p.roi);
        break;
      }
      case "date": {
        const month = ((p.auctionDays + 30) / 120);
        x = W + Math.min(1, Math.max(0, month)) * range;
        const cIdx = COUNTIES.findIndex(c => c.name === p.county);
        y = H + (cIdx + 0.5) / COUNTIES.length * range;
        color = p.auctionDays < 14 ? COLORS.danger : (p.auctionDays < 45 ? COLORS.warning : COLORS.brand);
        break;
      }
      case "fvi": {
        x = W + (p.fvi/10) * range;
        const valNorm = Math.min(1, p.tax/15000);
        y = H + (1 - valNorm) * range;
        color = p.fvi >= 7 ? COLORS.success : (p.fvi >= 5 ? COLORS.warning : COLORS.fg2);
        break;
      }
      case "type": {
        const tIdx = TYPES.indexOf(p.type);
        const col = tIdx % 2, row = Math.floor(tIdx / 2);
        const baseX = W + (col + 0.5) / 2 * range;
        const baseY = H + (row + 0.5) / 2 * range;
        x = baseX + (jit(p.id, 5) - 0.5) * 22;
        y = baseY + (jit(p.id, 13) - 0.5) * 24;
        color = colorByROI(p.roi);
        break;
      }
      case "priorYears": {
        x = W + (p.priorY/5) * range;
        const taxNorm = Math.min(1, p.tax/15000);
        y = H + (1 - taxNorm) * range;
        color = p.priorY >= 3 ? COLORS.danger : COLORS.brand;
        break;
      }
      case "exemptions": {
        const slot = p.homestead ? 0 : p.veteran ? 1 : p.senior ? 2 : 3;
        const col = slot % 2, row = Math.floor(slot/2);
        x = W + (col+0.5)/2 * range + (jit(p.id,9)-0.5)*20;
        y = H + (row+0.5)/2 * range + (jit(p.id,17)-0.5)*22;
        color = [COLORS.purple, COLORS.success, "#0EA5C7", COLORS.fg2][slot];
        break;
      }
      case "payback": {
        x = W + Math.min(1, p.payback/24) * range;
        y = H + (1 - Math.min(1, p.roi/0.30)) * range;
        color = p.payback <= 6 ? COLORS.success : (p.payback <= 12 ? COLORS.warning : COLORS.danger);
        break;
      }
      default: { // random / lasso default
        x = W + jit(p.id, 21) * range;
        y = H + jit(p.id, 23) * range;
        color = colorByROI(p.roi);
      }
    }
    return { ...p, x, y, size, color };
  });
}

// Compute stats for selection
function selectionStats(props) {
  if (!props.length) return null;
  const totalValue = props.reduce((s,p)=>s+p.value, 0);
  const avgRoi = props.reduce((s,p)=>s+p.roi, 0) / props.length;
  const lowR = props.filter(p => p.risk <= 35).length;
  const midR = props.filter(p => p.risk > 35 && p.risk <= 65).length;
  const hiR  = props.filter(p => p.risk > 65).length;
  return { totalValue, avgRoi, lowR, midR, hiR, count: props.length };
}

Object.assign(window, {
  COLORS, COUNTIES, STAGES, TYPES, PROPERTIES, Ico,
  TopBar, IconButton, BottomNav, StatTile, Badge, GalaxyDot,
  layoutFor, selectionStats, usd, usdFull, pct, radiusFromValue,
  colorByROI, colorByRisk, colorByStage,
});
