"""
ATS-Friendly Resume Generator
Generates resume in PDF, DOCX, and TXT formats optimized for ATS systems
"""

from reportlab.lib.pagesizes import letter
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import inch
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, PageBreak
from reportlab.lib.enums import TA_LEFT, TA_CENTER
from docx import Document
from docx.shared import Pt, RGBColor, Inches
from docx.enum.text import WD_ALIGN_PARAGRAPH
import os

class ATSResumeGenerator:
    def __init__(self):
        self.name = "Louis Miguel Bernal"
        self.phone = "+63 [phone redacted]"
        self.email = "miguellouis.work@gmail.com"
        self.linkedin = "https://www.linkedin.com/in/louisbernal/"
        self.github = "https://github.com/LouisMiguelBernal"
        
    def generate_pdf(self, filename="Louis_Miguel_Bernal_Resume.pdf"):
        """Generate ATS-friendly PDF resume"""
        doc = SimpleDocTemplate(filename, pagesize=letter,
                              topMargin=0.5*inch, bottomMargin=0.5*inch,
                              leftMargin=0.75*inch, rightMargin=0.75*inch)
        
        # Define styles
        styles = getSampleStyleSheet()
        
        # Custom styles for ATS compatibility
        title_style = ParagraphStyle(
            'CustomTitle',
            parent=styles['Heading1'],
            fontSize=16,
            textColor='black',
            spaceAfter=6,
            alignment=TA_CENTER,
            fontName='Helvetica-Bold'
        )
        
        contact_style = ParagraphStyle(
            'ContactStyle',
            parent=styles['Normal'],
            fontSize=9,
            alignment=TA_CENTER,
            spaceAfter=12
        )
        
        heading_style = ParagraphStyle(
            'CustomHeading',
            parent=styles['Heading2'],
            fontSize=12,
            textColor='black',
            spaceAfter=6,
            spaceBefore=8,
            fontName='Helvetica-Bold'
        )
        
        subheading_style = ParagraphStyle(
            'SubHeading',
            parent=styles['Normal'],
            fontSize=10,
            textColor='black',
            fontName='Helvetica-Bold',
            spaceAfter=4
        )
        
        body_style = ParagraphStyle(
            'BodyStyle',
            parent=styles['Normal'],
            fontSize=9,
            spaceAfter=4,
            leftIndent=20
        )
        
        # Build content
        content = []
        
        # Header
        content.append(Paragraph(self.name, title_style))
        contact_info = f"{self.phone} | {self.email}"
        content.append(Paragraph(contact_info, contact_style))
        links = f'<link href="{self.linkedin}">LinkedIn</link> | <link href="{self.github}">GitHub</link>'
        content.append(Paragraph(links, contact_style))
        content.append(Spacer(1, 0.1*inch))
        
        # Education
        content.append(Paragraph("EDUCATION", heading_style))
        content.append(Paragraph("<b>De La Salle University – Dasmariñas</b>, B.S. in Computer Science, GPA: 3.6 / 4.0 | Aug 2022 - May 2026", subheading_style))
        content.append(Paragraph("<b>Thesis:</b> VisorAI: A YOLOv11-Powered Mobile Application for Real-Time Detection of LTO Road Markings with Auditory Feedback", body_style))
        content.append(Paragraph("<b>Leadership:</b> DLSUD CSO - Executive Committee Director for Finance & Public Relations, CSITPC - Director for Programming & Creatives Committee", body_style))
        
        # Technical Skills
        content.append(Paragraph("TECHNICAL SKILLS", heading_style))
        content.append(Paragraph("<b>Database & SQL:</b> PostgreSQL, MySQL, SQLite, T-SQL, SQL Server, Database Design, Data Modeling, Schema Design, Indexing Strategies, Query Optimization", body_style))
        content.append(Paragraph("<b>ETL & Analytics Tools:</b> Power BI, SSRS, ETL/ELT Pipelines, Excel, Git, Data Warehousing, Multi-tenant Architecture", body_style))
        content.append(Paragraph("<b>Programming Languages:</b> Python, SQL, Dart, Java, HTML, CSS", body_style))
        content.append(Paragraph("<b>Data Science & AI Frameworks:</b> Pandas, Scikit-learn, NumPy, Seaborn, Matplotlib, PyTorch, TensorFlow, YOLOv11, Keras, Optuna, XGBoost", body_style))
        
        # Work Experience
        content.append(Paragraph("WORK EXPERIENCE", heading_style))
        content.append(Paragraph("<b>PASIA – Procurement and Supply Institute of Asia</b> | Makati City, Metro Manila", subheading_style))
        content.append(Paragraph("<i>Data Analyst Intern | Python, Jupyter Notebook, Scikit-learn, Pandas, Power BI, Excel, Git | June 2025 – Aug 2025</i>", body_style))
        content.append(Paragraph("• Automated large-scale data preprocessing pipelines using Python (pandas, scikit-learn) and machine learning-based imputation, processing over 1 million procurement and contract records, reducing manual effort by 85%", body_style))
        content.append(Paragraph("• Optimized ETL pipelines for automated ingestion and transformation of high-volume procurement data, ensuring 99% consistency across departments and daily data refreshes for real-time insights", body_style))
        content.append(Paragraph("• Designed and implemented database schemas and indexing strategies to handle high-volume queries, improving query performance by 40% for 1M+ records", body_style))
        content.append(Paragraph("• Developed advanced Power BI and Excel visualizations of private contractor procurement data, transforming 1M+ contract records into actionable business intelligence insights", body_style))
        
        # Database Projects
        content.append(Paragraph("DATABASE & DATA ENGINEERING PROJECTS", heading_style))
        
        projects = [
            {
                "title": "Bank Database Application",
                "tech": "Python, PostgreSQL, Git",
                "date": "Jan 2024 – Mar 2024",
                "bullets": [
                    "Designed and implemented a comprehensive banking database system with normalized schemas supporting customer accounts, transactions, loans, and employee management",
                    "Created robust data models with referential integrity constraints, triggers, and stored procedures to ensure ACID compliance and data consistency",
                    "Developed Python-based CRUD operations and transaction management system with rollback capabilities for financial data integrity"
                ]
            },
            {
                "title": "Bank Management SQL System",
                "tech": "SQL, MySQL, Database Design",
                "date": "Mar 2024 – May 2024",
                "bullets": [
                    "Architected a full-scale bank management system with complex relational schemas including account hierarchies, transaction logs, and audit trails",
                    "Implemented advanced SQL features including views, indexes, and stored procedures to optimize query performance for reporting and analytics",
                    "Designed multi-level security access controls and role-based permissions for different user types"
                ]
            },
            {
                "title": "PostgreSQL & Python Integration for Real Estate Analysis",
                "tech": "PostgreSQL, Python, Pandas, Git",
                "date": "May 2024 – June 2024",
                "bullets": [
                    "Built an integrated data pipeline connecting PostgreSQL database with Python analytics layer for real estate market analysis",
                    "Designed star schema data warehouse architecture to support OLAP operations and complex analytical queries",
                    "Implemented ETL processes to extract, transform, and load property data from multiple sources into centralized PostgreSQL database"
                ]
            }
        ]
        
        for project in projects:
            content.append(Paragraph(f"<b>{project['title']}</b> | <i>{project['tech']}</i> | {project['date']}", subheading_style))
            for bullet in project['bullets']:
                content.append(Paragraph(f"• {bullet}", body_style))
        
        # Certifications
        content.append(Paragraph("CERTIFICATIONS", heading_style))
        certs = [
            "Deep Learning Specialization – DeepLearning.AI (by Andrew Ng) | Dec 2025",
            "Data Science Workshop 2024 – De La Salle University | Sept 2024",
            "Accenture North America – Data Analytics & Visualization Job Simulation (Forage) | Jan 2024",
            "Data Analysis with Python – freeCodeCamp",
            "Google Analytics – Google"
        ]
        for cert in certs:
            content.append(Paragraph(f"• {cert}", body_style))
        
        # Build PDF
        doc.build(content)
        print(f"✓ PDF resume generated: {filename}")
        
    def generate_docx(self, filename="Louis_Miguel_Bernal_Resume.docx"):
        """Generate ATS-friendly DOCX resume"""
        doc = Document()
        
        # Set margins
        sections = doc.sections
        for section in sections:
            section.top_margin = Inches(0.5)
            section.bottom_margin = Inches(0.5)
            section.left_margin = Inches(0.75)
            section.right_margin = Inches(0.75)
        
        # Header
        heading = doc.add_paragraph()
        heading.alignment = WD_ALIGN_PARAGRAPH.CENTER
        run = heading.add_run(self.name)
        run.font.size = Pt(16)
        run.font.bold = True
        
        contact = doc.add_paragraph()
        contact.alignment = WD_ALIGN_PARAGRAPH.CENTER
        run = contact.add_run(f"{self.phone} | {self.email}")
        run.font.size = Pt(10)
        
        links = doc.add_paragraph()
        links.alignment = WD_ALIGN_PARAGRAPH.CENTER
        run = links.add_run(f"{self.linkedin} | {self.github}")
        run.font.size = Pt(9)
        
        # Education
        self._add_section_heading(doc, "EDUCATION")
        p = doc.add_paragraph()
        run = p.add_run("De La Salle University – Dasmariñas")
        run.bold = True
        p.add_run(", B.S. in Computer Science, GPA: 3.6 / 4.0 | Aug 2022 - May 2026")
        
        thesis = doc.add_paragraph()
        run = thesis.add_run("Thesis: ")
        run.bold = True
        thesis.add_run("VisorAI: A YOLOv11-Powered Mobile Application for Real-Time Detection of LTO Road Markings with Auditory Feedback")
        
        leadership = doc.add_paragraph()
        run = leadership.add_run("Leadership: ")
        run.bold = True
        leadership.add_run("DLSUD CSO - Executive Committee Director for Finance & Public Relations, CSITPC - Director for Programming & Creatives Committee")
        
        # Technical Skills
        self._add_section_heading(doc, "TECHNICAL SKILLS")
        skills = [
            ("Database & SQL:", "PostgreSQL, MySQL, SQLite, T-SQL, SQL Server, Database Design, Data Modeling, Schema Design, Indexing Strategies, Query Optimization"),
            ("ETL & Analytics Tools:", "Power BI, SSRS, ETL/ELT Pipelines, Excel, Git, Data Warehousing, Multi-tenant Architecture"),
            ("Programming Languages:", "Python, SQL, Dart, Java, HTML, CSS"),
            ("Data Science & AI Frameworks:", "Pandas, Scikit-learn, NumPy, Seaborn, Matplotlib, PyTorch, TensorFlow, YOLOv11, Keras, Optuna, XGBoost")
        ]
        for label, content in skills:
            p = doc.add_paragraph()
            run = p.add_run(label)
            run.bold = True
            p.add_run(f" {content}")
        
        # Work Experience
        self._add_section_heading(doc, "WORK EXPERIENCE")
        p = doc.add_paragraph()
        run = p.add_run("PASIA – Procurement and Supply Institute of Asia")
        run.bold = True
        p.add_run(" | Makati City, Metro Manila")
        
        p = doc.add_paragraph()
        run = p.add_run("Data Analyst Intern | Python, Jupyter Notebook, Scikit-learn, Pandas, Power BI, Excel, Git | June 2025 – Aug 2025")
        run.italic = True
        
        bullets = [
            "Automated large-scale data preprocessing pipelines using Python (pandas, scikit-learn) and machine learning-based imputation, processing over 1 million procurement and contract records, reducing manual effort by 85%",
            "Optimized ETL pipelines for automated ingestion and transformation of high-volume procurement data, ensuring 99% consistency across departments and daily data refreshes for real-time insights",
            "Designed and implemented database schemas and indexing strategies to handle high-volume queries, improving query performance by 40% for 1M+ records",
            "Developed advanced Power BI and Excel visualizations of private contractor procurement data, transforming 1M+ contract records into actionable business intelligence insights"
        ]
        for bullet in bullets:
            doc.add_paragraph(bullet, style='List Bullet')
        
        # Database Projects
        self._add_section_heading(doc, "DATABASE & DATA ENGINEERING PROJECTS")
        
        projects = [
            {
                "title": "Bank Database Application",
                "tech": "Python, PostgreSQL, Git",
                "date": "Jan 2024 – Mar 2024",
                "bullets": [
                    "Designed and implemented a comprehensive banking database system with normalized schemas supporting customer accounts, transactions, loans, and employee management",
                    "Created robust data models with referential integrity constraints, triggers, and stored procedures to ensure ACID compliance and data consistency",
                    "Developed Python-based CRUD operations and transaction management system with rollback capabilities for financial data integrity"
                ]
            },
            {
                "title": "Bank Management SQL System",
                "tech": "SQL, MySQL, Database Design",
                "date": "Mar 2024 – May 2024",
                "bullets": [
                    "Architected a full-scale bank management system with complex relational schemas including account hierarchies, transaction logs, and audit trails",
                    "Implemented advanced SQL features including views, indexes, and stored procedures to optimize query performance for reporting and analytics",
                    "Designed multi-level security access controls and role-based permissions for different user types"
                ]
            },
            {
                "title": "House Price Analysis Dashboard with Power BI & PostgreSQL",
                "tech": "Power BI, PostgreSQL, Git",
                "date": "June 2024 – July 2024",
                "bullets": [
                    "Developed and deployed an interactive House Price Analysis Dashboard using Power BI for dynamic visualizations and PostgreSQL for efficient data storage and querying",
                    "Implemented complex SQL queries to aggregate, clean, and transform large housing datasets",
                    "Created and optimized advanced Power BI reports with interactive filters and geographical visualizations"
                ]
            }
        ]
        
        for project in projects:
            p = doc.add_paragraph()
            run = p.add_run(project['title'])
            run.bold = True
            p.add_run(f" | {project['tech']} | {project['date']}")
            
            for bullet in project['bullets']:
                doc.add_paragraph(bullet, style='List Bullet')
        
        # Certifications
        self._add_section_heading(doc, "CERTIFICATIONS")
        certs = [
            "Deep Learning Specialization – DeepLearning.AI (by Andrew Ng) | Dec 2025",
            "Data Science Workshop 2024 – De La Salle University | Sept 2024",
            "Accenture North America – Data Analytics & Visualization Job Simulation (Forage) | Jan 2024",
            "Data Analysis with Python – freeCodeCamp",
            "Google Analytics – Google"
        ]
        for cert in certs:
            doc.add_paragraph(cert, style='List Bullet')
        
        doc.save(filename)
        print(f"✓ DOCX resume generated: {filename}")
    
    def _add_section_heading(self, doc, text):
        """Add a section heading to the document"""
        p = doc.add_paragraph()
        run = p.add_run(text)
        run.font.size = Pt(12)
        run.font.bold = True
        run.font.color.rgb = RGBColor(0, 0, 0)
    
    def generate_txt(self, filename="Louis_Miguel_Bernal_Resume.txt"):
        """Generate plain text resume for maximum ATS compatibility"""
        content = f"""
{self.name}
{self.phone} | {self.email}
{self.linkedin} | {self.github}

EDUCATION
De La Salle University – Dasmariñas, B.S. in Computer Science, GPA: 3.6 / 4.0
Aug 2022 - May 2026

Thesis: VisorAI: A YOLOv11-Powered Mobile Application for Real-Time Detection of LTO Road Markings with Auditory Feedback

Leadership: DLSUD CSO - Executive Committee Director for Finance & Public Relations, CSITPC - Director for Programming & Creatives Committee

TECHNICAL SKILLS
Database & SQL: PostgreSQL, MySQL, SQLite, T-SQL, SQL Server, Database Design, Data Modeling, Schema Design, Indexing Strategies, Query Optimization

ETL & Analytics Tools: Power BI, SSRS, ETL/ELT Pipelines, Excel, Git, Data Warehousing, Multi-tenant Architecture

Programming Languages: Python, SQL, Dart, Java, HTML, CSS

Data Science & AI Frameworks: Pandas, Scikit-learn, NumPy, Seaborn, Matplotlib, PyTorch, TensorFlow, YOLOv11, Keras, Optuna, XGBoost

WORK EXPERIENCE
PASIA – Procurement and Supply Institute of Asia | Makati City, Metro Manila
Data Analyst Intern | Python, Jupyter Notebook, Scikit-learn, Pandas, Power BI, Excel, Git
June 2025 – Aug 2025

- Automated large-scale data preprocessing pipelines using Python (pandas, scikit-learn) and machine learning-based imputation, processing over 1 million procurement and contract records, reducing manual effort by 85%
- Optimized ETL pipelines for automated ingestion and transformation of high-volume procurement data, ensuring 99% consistency across departments and daily data refreshes for real-time insights
- Designed and implemented database schemas and indexing strategies to handle high-volume queries, improving query performance by 40% for 1M+ records
- Developed advanced Power BI and Excel visualizations of private contractor procurement data, transforming 1M+ contract records into actionable business intelligence insights

DATABASE & DATA ENGINEERING PROJECTS

Bank Database Application | Python, PostgreSQL, Git | Jan 2024 – Mar 2024
- Designed and implemented a comprehensive banking database system with normalized schemas supporting customer accounts, transactions, loans, and employee management
- Created robust data models with referential integrity constraints, triggers, and stored procedures to ensure ACID compliance and data consistency
- Developed Python-based CRUD operations and transaction management system with rollback capabilities for financial data integrity

Bank Management SQL System | SQL, MySQL, Database Design | Mar 2024 – May 2024
- Architected a full-scale bank management system with complex relational schemas including account hierarchies, transaction logs, and audit trails
- Implemented advanced SQL features including views, indexes, and stored procedures to optimize query performance for reporting and analytics
- Designed multi-level security access controls and role-based permissions for different user types

PostgreSQL & Python Integration for Real Estate Analysis | PostgreSQL, Python, Pandas, Git | May 2024 – June 2024
- Built an integrated data pipeline connecting PostgreSQL database with Python analytics layer for real estate market analysis
- Designed star schema data warehouse architecture to support OLAP operations and complex analytical queries
- Implemented ETL processes to extract, transform, and load property data from multiple sources into centralized PostgreSQL database

House Price Analysis Dashboard with Power BI & PostgreSQL | Power BI, PostgreSQL, Git | June 2024 – July 2024
- Developed and deployed an interactive House Price Analysis Dashboard using Power BI for dynamic visualizations and PostgreSQL for efficient data storage and querying
- Implemented complex SQL queries to aggregate, clean, and transform large housing datasets
- Created and optimized advanced Power BI reports with interactive filters and geographical visualizations

Global Electric Vehicle PostgreSQL-Python Analysis | PostgreSQL, Python, Pandas, Seaborn | Aug 2024 – Sept 2024
- Designed and populated PostgreSQL database with global EV adoption data, implementing efficient indexing and partitioning strategies
- Developed complex SQL queries with window functions, CTEs, and subqueries to analyze regional trends
- Created automated reporting pipeline connecting PostgreSQL to Python visualization layer

Coffee Sales Power BI Dashboard | Power BI, SQL, Excel | Sept 2024 – Oct 2024
- Built comprehensive sales analytics dashboard integrating data from multiple sources
- Designed dimensional data model following star schema principles to enable efficient OLAP operations
- Implemented DAX calculations and measures for KPI tracking and time intelligence

CERTIFICATIONS
- Deep Learning Specialization – DeepLearning.AI (by Andrew Ng) | Dec 2025
- Data Science Workshop 2024 – De La Salle University | Sept 2024
- Accenture North America – Data Analytics & Visualization Job Simulation (Forage) | Jan 2024
- Data Analysis with Python – freeCodeCamp
- Google Analytics – Google
"""
        
        with open(filename, 'w', encoding='utf-8') as f:
            f.write(content.strip())
        print(f"✓ TXT resume generated: {filename}")
    
    def generate_all(self):
        """Generate all resume formats"""
        print("\n🚀 Generating ATS-Friendly Resumes...\n")
        self.generate_pdf()
        self.generate_docx()
        self.generate_txt()
        print("\n✅ All resume formats generated successfully!")
        print("\nFiles created:")
        print("  - Louis_Miguel_Bernal_Resume.pdf")
        print("  - Louis_Miguel_Bernal_Resume.docx")
        print("  - Louis_Miguel_Bernal_Resume.txt")

if __name__ == "__main__":
    generator = ATSResumeGenerator()
    generator.generate_all()