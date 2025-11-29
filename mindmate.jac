import:py from jaclang.core.llms, OpenAI;

# 1. Setup LLM 
# Replace with your actual OpenAI Key or use a local model if you know how.
glob llm = OpenAI(api_key="sk-..."); 

# 2. Define OSP Graph Structure
node User {
    has name: str;
}

node Entry {
    has content: str;
    has timestamp: str;
    has mood: str;
}

node Advice {
    has tip: str;
}

edge posted;
edge feeling;
edge suggested;

# 3. Agents (Walkers)

# Agent 1: The Logger (Analytic AI)
# Uses AI to classify mood and saves it to the graph
walker logger {
    has content: str;
    has timestamp: str;

    can classify_mood(text: str) -> str by llm(
        method="Reason",
        context="Classify the emotion of this text into one word (e.g., Happy, Sad, Anxious, Angry)."
    );

    can log_entry with `root entry {
        # AI Classification
        mood_label = self.classify_mood(self.content);
        
        # Create Nodes
        entry_node = spawn here ++> node::Entry(
            content=self.content, 
            timestamp=self.timestamp,
            mood=mood_label
        );
        
        # Report back for the UI
        report {"status": "success", "mood": mood_label, "node_id": str(entry_node)};
    }
}

# Agent 2: The Therapist (Generative AI)
# Reads the entry and generates advice
walker therapist {
    has content: str;
    has mood: str;

    can give_advice(text: str, mood: str) -> str by llm(
        method="Reason",
        context=f"The user feels {mood} because: '{text}'. Provide a short, actionable coping tip."
    );

    can provide_support with `root entry {
        # AI Generation
        advice = self.give_advice(self.content, self.mood);
        
        # Save to Graph (find the last entry to attach advice to)
        # For simplicity in this demo, we just report it.
        # In a full app, you'd traverse to the specific Entry node.
        
        report advice;
    }
}

# Agent 3: The History Reader
# Fetches previous entries for the timeline
walker history_reader {
    can fetch_history with `root entry {
        # Traverse outgoing 'posted' edges to find Entry nodes
        entries = -[posted]->;
        report entries;
    }
}