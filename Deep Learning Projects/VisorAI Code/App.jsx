import React from "react";

export default function App() {
  return (
    <div style={{ margin: 0, fontFamily: "Inter, sans-serif", backgroundColor: "#0f0f0f", color: "white" }}>
      
      <section style={{ height: "100vh", display: "flex", flexDirection: "column", justifyContent: "center", alignItems: "center", textAlign: "center", padding: "20px" }}>
        <h1 style={{ fontSize: "56px", fontWeight: "bold", marginBottom: "20px" }}>
          Louis Miguel Bernal
        </h1>
        <p style={{ maxWidth: "600px", color: "#aaaaaa", fontSize: "18px" }}>
          Computer Science student specializing in AI, Machine Learning, and Full-Stack Development.
          I build intelligent systems and scalable web applications.
        </p>

        <div style={{ marginTop: "30px", display: "flex", gap: "20px" }}>
          <a
            href="#projects"
            style={{
              padding: "12px 24px",
              backgroundColor: "white",
              color: "black",
              textDecoration: "none",
              borderRadius: "8px",
              fontWeight: "bold"
            }}
          >
            View Projects
          </a>

          <a
            href="mailto:miguellouis.work@gmail.com"
            style={{
              padding: "12px 24px",
              border: "1px solid white",
              color: "white",
              textDecoration: "none",
              borderRadius: "8px"
            }}
          >
            Contact
          </a>
        </div>
      </section>

      <section id="projects" style={{ padding: "80px 20px", textAlign: "center" }}>
        <h2 style={{ fontSize: "40px", marginBottom: "50px" }}>Projects</h2>

        <div style={{ display: "flex", flexWrap: "wrap", justifyContent: "center", gap: "40px" }}>
          
          <div style={{ maxWidth: "300px", backgroundColor: "#1a1a1a", padding: "20px", borderRadius: "12px" }}>
            <h3>VisorAI</h3>
            <p style={{ color: "#bbbbbb" }}>
              YOLOv11-powered helmet detection system with real-time monitoring and Streamlit dashboard.
            </p>
          </div>

          <div style={{ maxWidth: "300px", backgroundColor: "#1a1a1a", padding: "20px", borderRadius: "12px" }}>
            <h3>QuantMaven</h3>
            <p style={{ color: "#bbbbbb" }}>
              Stock research dashboard featuring financial indicators and algorithmic ranking systems.
            </p>
          </div>

          <div style={{ maxWidth: "300px", backgroundColor: "#1a1a1a", padding: "20px", borderRadius: "12px" }}>
            <h3>XGE</h3>
            <p style={{ color: "#bbbbbb" }}>
              XGBoost-powered CO₂ emissions prediction web app with visualization and evaluation tools.
            </p>
          </div>

        </div>
      </section>

      <footer style={{ textAlign: "center", padding: "30px", backgroundColor: "#111", color: "#777" }}>
        © {new Date().getFullYear()} Louis Miguel Bernal
      </footer>

    </div>
  );
}