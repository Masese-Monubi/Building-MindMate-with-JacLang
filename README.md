# 🧠 MindMate Harmony Space
### AI-Powered Mental Wellbeing Companion

> **Assignment Submission**
> * **Language:** JacLang
> * **Framework:** Jaseci (Jac Cloud) / Streamlit
> * **Focus:** OSP Graph, Multi-Agent Systems, Generative AI (byLLM)

---

## 📖 Project Overview
**MindMate Harmony Space** is a compassionate digital companion designed to track emotional trends and offer personalized coping strategies. Unlike traditional CRUD applications, MindMate models human emotion as a **Knowledge Graph (OSP)**.

It utilizes **Agentic AI (Walkers)** to traverse this graph, classify emotional states using Large Language Models (LLM), and generate empathetic advice based on the user's history.

---

## 🏗️ Technical Architecture

### 1. Object-Oriented Structure (OSP)
The application state is not stored in tables, but in a semantic graph:

* **Nodes:**
    * `User`: The root of the personal graph.
    * `Entry`: A specific journal log containing the raw text and timestamp.
    * `Advice`: AI-generated coping mechanisms linked to specific entries.
* **Edges:**
    * `posted`: Connects User to Entry.
    * `suggested`: Connects Entry to Advice.

### 2. Multi-Agent Design (Walkers)
The system employs three distinct agents (Walkers) to handle logic:

| Agent Name | Type | Responsibility |
| :--- | :--- | :--- |
| **Logger** | Analytical | Takes raw input, uses **byLLM** to classify the sentiment (Reasoning), and constructs the Graph nodes. |
| **Therapist** | Generative | Traverses to the specific entry, analyzes the mood, and generates actionable advice using **byLLM**. |
| **HistoryReader**| Utility | Traverses the graph to fetch historical data for the frontend timeline visualization. |

### 3. Agent Interaction Flow
```mermaid
sequenceDiagram
    participant User
    participant Client as Jac-Client (Streamlit)
    participant Logger as Walker: Logger
    participant Graph as OSP Graph
    participant Therapist as Walker: Therapist
    participant LLM as OpenAI

    User->>Client: Enters "I feel anxious"
    Client->>Logger: Spawn Logger(content)
    Logger->>LLM: Classify Mood (Analytical)
    LLM-->>Logger: "Anxious"
    Logger->>Graph: Create Node::Entry + Edge
    Client->>Therapist: Spawn Therapist(entry)
    Therapist->>LLM: Generate Advice (Generative)
    LLM-->>Therapist: "Try 4-7-8 Breathing"
    Therapist-->>Client: Return Advice
    Client-->>User: Display Advice