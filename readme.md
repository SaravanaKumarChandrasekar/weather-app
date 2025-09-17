# Weather App — DevOps Demo

## Overview
This project demonstrates a containerized weather web application using **DevOps best practices**:

- **Docker + Docker Compose**: Containerized backend (Flask API) and frontend (HTML/Nginx)  
- **Nginx reverse proxy**: Serves frontend and proxies API to avoid CORS  
- **Environment variables**: Secrets like `OPENWEATHER_API_KEY` are stored outside code  
- **API testing**: Using `curl` or Postman  
- **Monitoring & Automation ready**: Can integrate with Prometheus/Grafana, Terraform, Ansible  

This project is intended as a **DevOps demo**, showing how services communicate, are deployed, and configured professionally.  

---

## Project Structure

