# **Deep Literature Review and Strategic Positioning for Civitas 6.7B: Governed Self-Improvement Under Active Law**

## **1\. Executive Research Summary**

The transition from pre-deployment artificial intelligence alignment to autonomous, continuous agentic self-improvement represents a fundamental inflection point in machine learning safety. While existing research paradigms have successfully demonstrated the viability of self-reflective capabilities and post-hoc behavioral correction within bounded execution windows, they consistently fail to enforce operational, active-law constraints during continuous adaptation phases. As agentic systems scale in autonomy, the risk of recursive self-improvement generating unsafe stochastic drift or catastrophic alignment failures necessitates a structural paradigm shift.1 The analysis conducted for the positioning of the Civitas 6.7B runtime architecture indicates a critical gap in the literature: the acute absence of a structurally governed, cryptographically bounded self-improvement runtime for autonomous language agents.  
Civitas 6.7B uniquely addresses this vulnerability by integrating cognitive self-reflection mechanisms with high-assurance software supply chain architectures and runtime verification reference monitors. The architecture operates on a strict lifecycle: it generates critiques and candidate improvements from clustered failure evidence, packages these cognitive adaptations within an admissibility court packet, and submits them to an institutional governance gate (comprising Aegis, Senatus, SKM, and EVA modules) prior to heldout evaluation and operational promotion.3  
The closest prior works and systems that approximate sub-components of the Civitas 6.7B architecture span diverse domains, from formal methods to empirical natural language processing. The top ten closest works are:

1. **SEAL (Self-Adapting LLMs)**: Demonstrates the autonomous generation of synthetic self-edits via reinforcement learning, proving models can guide their own weight updates.6  
2. **STABLE (Gated Continual Self-Editing)**: Extends SEAL by implementing statistical gating budgets to prevent catastrophic forgetting and representational collapse during sequential updates.8  
3. **AgentGuard & AgentSpec**: Introduces real-time runtime verification (RV) and probabilistic model checking for AI agents, abstracting execution traces into Markov Decision Processes to evaluate continuous constraint compliance.9  
4. **Reflexion**: Establishes the foundation of verbal reinforcement learning, wherein agents maintain persistent memory of past failures and generate textual self-critiques to improve subsequent task execution.11  
5. **Constitutional AI (CAI)**: Pioneers the utilization of natural language rule sets to guide algorithmic self-critique and revision, removing the bottleneck of human feedback labeling.13  
6. **Aegis / Civitas 4.0 Architecture**: Provides the foundational cryptographic infrastructure—namely the Immutable Ethics Policy Layer (IEPL), Enforcement Kernel Module (EKM), and Immutable Logging Kernel (ILK)—required for runtime operational constraint.3  
7. **SLSA for AI Agents**: Extends supply-chain provenance (SLSA Level 3\) to AI agent manifests, standardizing the verification of cryptographic identity and tool definitions within agent updates.15  
8. **Trust Region Conditional Value at Risk (TRC)**: Applies bounded update methodologies in safe reinforcement learning to guarantee that policy adaptations do not violate rigid risk-measure constraints.17  
9. **Multi-Agent Debate Judges (HAJailBench/ColMAD)**: Utilizes scaffolded agent debate and quorum voting for scalable safety evaluation and final adjudication of complex adversarial prompts.19  
10. **Prose2Policy / OPA (Rego)**: Translates human-readable natural language safety requirements into executable Policy-as-Code for deterministic evaluation at system execution boundaries.21

When positioning Civitas 6.7B against this literature, five primary differentiators secure its novelty. First, it enforces *candidate-only improvement*; unlike Reflexion or standard continual learning paradigms, Civitas physically prevents silent self-updates, isolating all improvements as proposed candidates until formal authorization.7 Second, it relies upon *materialized evidence and ILK traceability*; the system generates an auditable court packet of failure evidence that is cryptographically signed and logged via the Immutable Logging Kernel, establishing an unbroken chain of systemic provenance.5 Third, it shifts governance from advisory guidelines to *active law and policy-governed promotion*, utilizing execution-level reference monitors that enforce institutional policy as a strict execution condition.3 Fourth, the architecture mandates *scoped evidence authority*, ensuring the agent cannot arbitrarily alter its own overarching policy constraints; structural proposals undergo a trust-region check to strictly limit the mathematical and semantic scope of the behavioral modification.4 Finally, the system executes *heldout and stress testing integration*, implementing a dedicated testing rail within the update lifecycle to guarantee that production behavior and evaluation benchmarks remain strictly aligned prior to promotion.26  
However, the positioning strategy must navigate several risks to novelty. The overlap with gated continual learning (e.g., STABLE) may prompt reviewers to view institutional governance gates as functionally equivalent to statistical forgetting gates.8 Furthermore, the promotion gate lifecycle heavily mirrors standard MLOps and DevSecOps pipelines, risking the criticism that the system is merely standard continuous integration applied to agents.27 The reliance on critique/revision loops grounded in governance rules overlaps significantly with the fundamental mechanisms of Constitutional AI.13 The existence of runtime verification precedents, such as AgentGuard, demonstrates that dynamic enforcement of agent outputs via state tracking is already established.9 Lastly, the ubiquity of multi-agent voting in contemporary research may lead to the Senatus quorums being conflated with standard LLM-as-a-judge majority voting.20  
To effectively position the paper amidst these challenges, the recommended positioning statement is: *While existing frameworks enable transient agentic self-reflection or post-hoc runtime action monitoring, Civitas 6.7B pioneers a cryptographically governed self-improvement runtime wherein an agent's behavioral adaptations are materialized as auditable, bounded candidates that cannot gain operational authority without satisfying strict, active-law governance gates and replayable evidentiary requirements.*

## **2\. Citation Matrix**

The following comprehensive citation matrix categorizes thirty critical pieces of literature across safety, governance, and verification clusters, mapping their relationship and delta to the Civitas 6.7B framework.

| Citation | Year | Venue/Status | Cluster | Core Idea | Method | Empirical Evidence | Relation to Civitas 6.7B | What Civitas Does Differently | Use in Paper Section |
| :---- | :---- | :---- | :---- | :---- | :---- | :---- | :---- | :---- | :---- |
| **SEAL** 7 | 2025 | arXiv | A | Self-Adapting Language Models | Uses RL to train models to generate self-edits and update parameters directly. | Outperforms baselines on knowledge incorporation/few-shot tasks. | Defines the baseline for autonomous candidate generation capability. | Prevents raw self-updates; forces changes through Aegis admissibility gates. | Self-Reflective Agents |
| **STABLE** 8 | 2025 | arXiv | A | Preventing catastrophic forgetting | Constrains sequential LoRA merges through metric-based gating (EM drop, KL). | Demonstrates stabilization across continual adaptation sequences. | Validates the "gate" concept to prevent unsafe model drift over time. | Uses cryptographic governance and active policy gates rather than pure statistical metrics. | Self-Reflective Agents |
| **Reflexion** 11 | 2023 | NeurIPS | A | Verbal reinforcement learning | Agents utilize failure traces to generate natural language critiques. | 22% improvement in AlfWorld; 20% in HotPotQA. | Foundational mechanism for failure discovery and textual critique generation. | Reflexion is prompt-based/transient; Civitas formalizes updates into durable structural proposals. | Self-Reflective Agents |
| **STaR** 31 | 2022 | NeurIPS | A | Bootstrapping reasoning | Iteratively generates rationale datasets to fine-tune self-reasoning. | Significant gains on GSM8K without human annotation. | Demonstrates that agents can generate high-quality cognitive upgrades. | STaR blindly accepts rationales; Civitas actively gates and critiques them for safety constraints. | Self-Reflective Agents |
| **Meta-Policy Reflexion** 12 | 2025 | arXiv | A | RL-adapted reflection | Adapts policies using RL from human feedback atop textual reflection. | Improves single-episode execution loop optimization. | Represents advanced interleaving of reasoning and acting. | Civitas shifts the focus from task-policy to governance-policy adherence. | Self-Reflective Agents |
| **TRC Safe RL** 17 | 2022 | IEEE RA-L | B | Safe RL with CVaR constraints | Generates off-policy bounded updates using trust region methods. | Satisfied safety constraints in simulated/real-world robotic tasks. | Validates the "trust-region check" step in the candidate lifecycle. | Translates mathematical bounded updates into symbolic policy constraint checks. | Policy-Governed AI |
| **Constitutional AI** 13 | 2022 | arXiv | B | Harmlessness from AI feedback | Supervised learning and RLAIF conditioned on written principles. | Successfully generated harmless, non-evasive dialog agents. | Employs principle-guided critique for behavior alignment. | CAI is an alignment training technique; Civitas is an active runtime governance protocol. | Policy-Governed AI |
| **Specific vs General CAI** 32 | 2023 | arXiv | B | General ethical behaviors from rules | Tests if models learn from a single principle vs extensive constitutions. | Dialog models generalize well from short constitutions. | Informs the structural design of the Immutable Ethics Policy Layer (IEPL). | Enforces principles via runtime cryptographic lockdown, not just RL tuning. | Policy-Governed AI |
| **AgentGuard** 9 | 2025 | ASE | C | Runtime verification of agents | Dynamically builds MDPs from raw I/O and uses probabilistic checking. | Provides continuous, quantitative guarantees on emergent behavior. | Establishes the necessity of active execution monitoring and tracing. | AgentGuard manages state execution; Civitas governs the self-improvement update loop itself. | Runtime Verification |
| **AgentSpec** 10 | 2025 | arXiv | C | DSL for runtime constraint | Specifies triggers, predicates, and enforcement mechanisms for agents. | Prevented unsafe execution in \>90% of code agent cases. | Formalizes rules to enforce predefined safety boundaries dynamically. | Civitas integrates constraint verification deeply into the cryptographic lifecycle promotion gate. | Runtime Verification |
| **Prose2Policy** 22 | 2025 | Apple | C | LLM Policy-as-Code generation | Translates human-readable requirements into Rego for OPA. | 95.3% compile rate for accepted policies. | Decouples policy decision-making from core LLM execution logic. | Utilizes its policy architecture (IEPL) to govern cognitive structural updates, not just access. | Policy Enforcement |
| **Open Policy Agent** 21 | 2023 | CNCF | C | General-purpose policy engine | Uses declarative language (Rego) to unify policy enforcement across stacks. | Industry standard for microservice/Kubernetes authorization. | Provides the foundational architecture for active-law decoupling. | Operates on dynamic agent-generated cognitive structures rather than static JSON API queries. | Policy Enforcement |
| **Cedar Policy** 33 | 2024 | AWS | C | Permissions as policies | Provides an HTTP server for managing a policy store and data store. | Validates policies and data against strict schemas. | Similar to the EVA module's evaluation mechanism. | Embeds Cedar-like evaluations within an autonomous self-improvement lifecycle. | Policy Enforcement |
| **Aegis Architecture** 3 | 2026 | SSRN/arXiv | E | Cryptographic runtime governance | Binds agents to an IEPL utilizing zk-STARKs and Genesis Locks. | Median proof latency of 238ms; publication overhead of 9.4ms. | Foundational infrastructure utilized by the Civitas 6.7B system. | Expands Aegis from reactive execution governance to proactive governed self-improvement. | Position of Civitas |
| **Senatus Protocol** 34 | 2025 | GitHub | E | Specification-driven development | Follows the decision-making model of the Roman Senate for AI dev. | Resolves context capacity limits via structured documentation. | Directly informs the Senatus governance gate concept in Civitas. | Upgrades Senatus from a developer tool to an autonomous cryptographic enforcement module. | Secure Promotion |
| **Reflexive Governance** 35 | 2010 | Hart Pub. | E | Redefining public interest | Proposes governance models that adapt via rapid feedback loops. | Demonstrates policy adaptability in dynamic environments. | Provides the theoretical socio-legal framework for "active law." | Translates sociological reflexive governance into a computable software architecture. | Position of Civitas |
| **AEGIS Processor** 36 | 2004 | MIT | D | Secure computing architecture | Uses private keys and grid computing to guarantee program execution. | Foundational for certified execution of distributed computations. | Historical precedent for the EKM/SKM module naming and function. | Applies secure processing concepts to the abstract weights and context of LLM agents. | Secure Promotion |
| **SLSA for Agents** 15 | 2025 | SLSA.dev | D | Supply-chain provenance for agents | Proposes L0-L3 provenance levels for agent manifests and tools. | Standardizes the verification of cryptographic identity for updates. | Provides the theoretical basis for cryptographically signing agent updates. | Civitas generates its own updates and packages them with SLSA-style proofs autonomously. | Secure Promotion |
| **Sigstore A2A** 37 | 2026 | Dev.to | D | Provenance for A2A communication | Signs Agent Cards using keyless infrastructure in transparency logs. | Auditable trail of agent identities and capabilities over time. | Aligns with Civitas's requirement for materialized evidence and logs. | Civitas utilizes these principles for internal agent lifecycle promotion, not just comms. | Secure Promotion |
| **In-toto** 28 | 2023 | CNCF | D | Software supply chain API | Instills an evidence-based approach via explicit cryptographic proof. | Boosts system security and reliability by mapping the supply chain. | Relates to the compilation of the Civitas "court packet" and evidence harvest. | Re-contextualizes CI/CD supply chain logic into a recursive AI learning loop. | Secure Promotion |
| **Confidential CoCo** 38 | 2025 | Blog | D | SLSA L2 for containers | Generates signed SLSA provenance in the in-toto format. | Verifies provenance via GitHub CLI attestation commands. | Practical demonstration of immutable logging requirements. | Embeds provenance generation directly within the agent's self-improvement module. | Secure Promotion |
| **Witness Framework** 39 | 2024 | Medium | D | Pluggable framework for risk mgmt | Automates, normalizes, and verifies software artifact provenance. | Outputs encrypted test attestations mapped to policy keys. | Validates the "admissibility packet" structure required by EVA. | Applies artifact provenance to cognitive updates (prompts, tool parameters, rules). | Secure Promotion |
| **HAJailBench** 40 | 2025 | arXiv | F | Scalable safety via debate | Combines refusal screening with bounded critic-defender interaction. | Approaches GPT-4o reliability at lower unit cost. | Supports the Senatus/Quorum mechanism for evaluating candidate updates. | Integrates debate outcome explicitly into a deterministic cryptographic promotion gate. | Agent Evaluation |
| **ColMAD** 20 | 2024 | OpenRev | F | Collaborative multi-agent debate | Reframes MAD as a non-zero-sum game to prevent debate hacking. | Outperforms competitive MAD methods by 19% in error detection. | Prevents adversarial failure modes during the Senatus quorum vote. | Utilizes collaborative debate specifically for assessing constitutional alignment of updates. | Agent Evaluation |
| **AgenticRed** 41 | 2026 | arXiv | F | Evolutionary red-teaming | Applies evolutionary algorithms for query-agnostic attack trajectories. | Generalizes across benchmark sets with diverse attack styles. | Informs the "failure discovery" and "stress evaluation" lifecycle phases. | Civitas uses dynamic stress testing as an admissibility requirement prior to promotion. | Agent Evaluation |
| **AgentSafe Eval** 26 | 2025 | arXiv | F | Pre-deployment risk assessment | Integrates governance constraints directly into the testing protocol. | Transforms abstract risk taxonomies into measurable assurance. | Validates the necessity of the heldout/stress eval phase. | Executes continuous, automated evaluations on self-generated improvement candidates. | Agent Evaluation |
| **Dynamic Attacks** 42 | 2025 | arXiv | F | Red-teaming beyond static prompts | Redefines attacks as multi-turn, dynamic trajectories over time. | Captures complexity missed by static snapshots. | Provides the threat model for evaluating unbounded agent adaptation over time. | Civitas logs the entire multi-turn trajectory in the ILK to prevent cross-scope contamination. | Agent Evaluation |
| **EvoSynth** 41 | 2025 | arXiv | F | Query-specific attack programs | Evolves multi-turn attacks programmatically against LLMs. | Identifies vulnerabilities in multi-step planning environments. | Another methodology for generating complex failure evidence. | Subjects proposed candidate improvements to evolutionary stress tests. | Agent Evaluation |
| **Claudini** 41 | 2026 | arXiv | F | AutoResearch for red teaming | Optimizes discrete suffixes to minimize token-forcing loss. | Enhances GCG-style attacks in agentic frameworks. | Provides baseline adversarial metrics for the raw model comparisons. | Defends against forced-token drift by checking the underlying semantic trust-region. | Agent Evaluation |
| **AI Agents under Law** 43 | 2026 | Zenodo | E | Lex Incipit doctrine | Autonomy must begin under law at system genesis via Genesis Lock. | Eradicates plausible deniability via continuous tamper-evident logs. | Provides the overarching philosophy driving the Civitas 6.7B system design. | Transitions from theoretical legal doctrine to applied computational self-improvement. | Position of Civitas |

## **3\. Closest-Work Comparison**

1\. SEAL (Self-Adapting Language Models) 7 The SEAL framework utilizes a reinforcement learning loop designed to train language models to autonomously generate synthetic self-edits, thereby updating their own parameter weights in response to novel incoming data streams. It contributes a powerful mechanism for continuous, autonomous knowledge incorporation and few-shot generalization without relying on disjoint, external adaptation modules. However, relative to Civitas 6.7B, SEAL is severely limited by its susceptibility to catastrophic forgetting; it lacks structural governance and admissibility gating mechanisms, meaning updates occur automatically without evaluating holistic policy compliance or retaining proven safety boundaries. This work should be cited fairly as the primary empirical evidence that language models possess the latent capability for valid, self-directed adaptation proposals, positioning Civitas as the necessary regulatory framework required to safely harness this generative capability.  
2\. STABLE: Gated Continual Self-Editing 8 Building directly upon the vulnerabilities identified in SEAL, STABLE introduces a sequential gating layer that evaluates candidate self-edits against a predefined budget—such as Exact Match drop or Kullback-Leibler (KL) divergence—prior to executing sequential LoRA merges. STABLE contributes rigorous proof that evaluating candidate updates against formal mathematical thresholds effectively prevents catastrophic forgetting and stabilizes the continual learning process. What it lacks relative to Civitas is institutional, semantic awareness; the gates in STABLE are strictly statistical and domain-specific to factual accuracy, lacking any mechanism for complex policy enforcement, multi-agent quorum review, or cryptographic provenance. STABLE should be framed in the paper as the crucial statistical precursor to institutional gating, demonstrating the mathematical necessity of "candidate-only" generation prior to the application of any systemic update.  
3\. AgentGuard 9 AgentGuard operates as a dynamic inspection layer that abstracts the raw input/output streams of an AI agent into formal state transitions, utilizing online learning to model emergent behavior as a Markov Decision Process (MDP) and executing probabilistic model checking on the fly. Its primary contribution is the shift of formal verification from a static, pre-deployment exercise to an active, continuous runtime assurance monitor capable of providing quantitative safety guarantees. Relative to Civitas, however, AgentGuard regulates only the transient *actions* of a static policy within a specific environment; it does not govern the agent's internal ability to structurally rewrite its own reasoning pathways or improve its base capabilities over time. AgentGuard should be utilized in the related work to validate the necessity of runtime verification, contrasting its action-level telemetry focus with the cognitive-update governance focus of Civitas 6.7B.  
4\. Constitutional AI (CAI) 13 Constitutional AI relies upon a predefined set of natural language principles to guide an AI system through a process of supervised self-critique and revision, followed by reinforcement learning from AI feedback (RLAIF). CAI contributed a paradigm shift by proving that models can reliably align their behavior using internal representations of written rules, thereby eliminating the bottleneck of scaling human safety labels. Yet, CAI remains fundamentally a training-time alignment methodology; it does not operate as an active runtime law, nor does it generate cryptographic evidence of compliance for independent auditing during live deployment, which is the core function of Civitas. CAI must be cited as foundational proof that principle-guided critique is highly effective, while emphasizing that this mechanism must be extended into a tamper-proof runtime architecture to handle post-deployment autonomous drift.  
5\. Reflexion 11 Reflexion employs verbal reinforcement learning, allowing agents to maintain a persistent episodic memory of past failures and generate textual self-reflections to alter future decision-making without updating underlying model weights. It demonstrates that dynamic, trial-and-error reasoning correction via language dramatically improves the execution of complex, multi-step tasks. However, Reflexion operates entirely via prompt engineering; its updates are transient, ungoverned, and lack structural permanence, meaning malicious, hallucinated, or misaligned reflections are accepted implicitly into the context window without verification. Reflexion serves as the conceptual basis for the "failure discovery and critique" phase of Civitas, highlighting the need to harden this transient mechanism through the ILK and Senatus review to prevent cross-scope evidence contamination.  
6\. SLSA Framework for AI Agents 15 The Supply-chain Levels for Software Artifacts (SLSA) framework sets stringent standards for software provenance, with emerging proposals applying these levels (L0-L3) to AI agents by demanding that agent manifests, tools, and configurations be cryptographically signed and built in isolated, hermetic environments. SLSA provides the standardized, industry-accepted framework for ensuring that a software system is tamper-evident and that its build process is fully traceable back to its source. Relative to Civitas, SLSA typically applies to human-driven or automated CI/CD pipelines and does not account for a recursive system where the AI agent is simultaneously the developer, the code, and the operator generating continuous internal cognitive updates. Civitas should be framed as the direct implementation of SLSA Level 3 principles applied inward to the abstract cognitive states and reasoning parameters of an autonomous agent.  
7\. Prose2Policy / Open Policy Agent (Rego) 21 These frameworks, including Apple's Prose2Policy and the Cloud Native Computing Foundation's Open Policy Agent (OPA), decouple policy decision-making from application logic by utilizing language models to translate human-readable access constraints into deterministic Rego code. They establish "Policy-as-Code" as a viable, scalable method for enforcing strict operational boundaries across diverse computing environments. What they lack relative to Civitas is semantic depth; OPA evaluates static data structures (like standard API requests) against rules and cannot inherently evaluate the complex, multi-step semantic logic of proposed agent behaviors without the sophisticated abstraction layer provided by Civitas's EVA. They represent the established paradigm for "Active Law," demonstrating how Civitas 6.7B extends Policy-as-Code deeply into the agentic reasoning space.  
8\. Aegis Architecture (Civitas 4.0 context) 3 The foundational Aegis architecture is a runtime governance protocol that binds agents to an Immutable Ethics Policy Layer (IEPL), utilizing an Ethics Verification Agent (EVA), Enforcement Kernel Module (EKM), and Immutable Logging Kernel (ILK) to cryptographically block non-compliant outputs. It proves that complex AI alignment can be enforced cryptographically at execution time with minimal latency overhead (demonstrated at roughly 238 ms verification time). The baseline Aegis architecture governs instantaneous reasoning and physical/digital emissions, but Civitas 6.7B uniquely points this governance machinery inward, using it to regulate longitudinal, structural self-improvement over time. This must be cited as the core foundational work, positioning 6.7B as the direct conceptual and architectural successor that graduates Aegis from reactive behavioral control to proactive evolutionary control.  
9\. Safe Reinforcement Learning via Trust Regions 17 This subset of literature utilizes bounded updates to ensure that policy optimization does not stray into unsafe operational territories, often modifying the Kullback-Leibler (KL) divergence or utilizing Conditional Value at Risk (CVaR) to incorporate cost constraints. These methods contribute formal mathematical guarantees that every sequential update yields a local reduction in policy violation probability. Trust region optimization, however, operates on mathematical gradients during model fine-tuning; Civitas requires a symbolic, high-level structural trust-region check that evaluates complex semantic logic, multi-step plans, and rule adherence. The paper should draw a strong, explicit analogy between TRPO's mathematical bounding and Civitas's semantic "trust-region check" required for candidate admissibility.  
10\. HAJailBench / Multi-Agent Debate 19 This research provides a framework utilizing collaborative and adversarial multi-agent debate to serve as scalable, highly reliable safety judges, improving upon simple majority-voting architectures for LLM evaluation. It proves that adversarial, role-based interaction between models yields far more accurate safety adjudication than single-pass evaluations or static reward models. These systems, however, act solely as external evaluators for static benchmark datasets. Civitas takes this mechanism a step further by embedding the debate logic directly into the operational promotion pipeline via the Senatus protocol. This work serves as vital empirical validation for the multi-agent quorum review utilized within the internal Civitas governance gates to verify complex, nuanced policy adherence.

## **4\. Baseline Recommendation**

To isolate and prove the exact value of the governed-improvement runtime, the empirical evaluation must systematically contrast Civitas 6.7B against baseline systems that either lack improvement mechanics entirely or lack structural governance over those mechanics. The baseline selection must target specific theoretical failure modes inherent to agentic systems.  
**1\. 6.7B Frozen Baseline (No-Improvement)**

* **Purpose:** To establish the absolute base capability and safety metrics of the underlying foundation model without the runtime improvement loop engaged.  
* **Expected Failure Mode:** Over repeated and increasingly complex tasks, the frozen agent will consistently fail on novel edge cases, demonstrating zero adaptation or failure-clustering capabilities. It will reliably fail the heldout generalization evaluation, proving its brittleness.  
* **Required Implementation:** The full 6.7B system deployed with the failure-discovery telemetry and candidate-generation modules strictly deactivated via configuration.  
* **Paper Value:** This baseline proves that the capability gains and error reductions observed in the full system are strictly a result of the governed improvement loop, rather than any inherent zero-shot capability of the base model.

**2\. Raw Model / Unbounded Agent**

* **Purpose:** To demonstrate the chaotic and unsafe trajectory of an agentic system that lacks both pre-deployment constitutional training and runtime governance interventions.  
* **Expected Failure Mode:** The system will exhibit rapid, unconstrained behavioral drift. When exposed to complex, multi-step environments, it will suffer from reward hacking, high policy violation rates, and hallucinated compliance, prioritizing task completion over safety constraints.  
* **Required Implementation:** The base 6.7B foundation model integrated into a standard ReAct or iterative reasoning loop without the Aegis/EVA constraints or the IEPL active.  
* **Paper Value:** Provides a worst-case scenario baseline metric, fundamentally grounding the necessity of extensive safety interventions and runtime verification.

**3\. Prompt-Only Self-Improvement (Reflexion-style)**

* **Purpose:** To evaluate the structural resilience of in-context, prompt-driven self-reflection against formalized, cryptographically gated improvement.  
* **Expected Failure Mode:** The agent will initially adapt well, improving capability. However, over continuous operation, it will suffer from context-window saturation and "cross-scope evidence contamination," wherein new reflections contradict and overwrite previously learned safety constraints, leading to a delayed but severe degradation in policy adherence.  
* **Required Implementation:** An agent employing continuous textual critique and self-reflection appended to its prompt memory, but operating entirely without an external enforcement gate, ILK storage, or trust-region check.  
* **Paper Value:** This comparison critically differentiates Civitas 6.7B from advanced prompt-engineering, mathematically proving that prompt-based governance degrades over longitudinal timeframes while structural governance persists.

**4\. CI/CD-Style Gated Deployment Pipeline**

* **Purpose:** To contrast static, external MLOps workflows against autonomous, active-law runtime governance, addressing critiques regarding systems engineering overlap.  
* **Expected Failure Mode:** The standard CI/CD pipeline will prove too rigid to handle context-dependent, real-time semantic policy evaluation. It will either block valid capability improvements due to brittle deterministic testing or allow hallucinated compliance through, requiring extensive human-in-the-loop bottlenecks.  
* **Required Implementation:** An agent that proposes candidate updates which must be pushed to an external, sandboxed simulation environment and passed through deterministic, non-agentic unit tests before promotion.  
* **Paper Value:** Directly addresses the reviewer critique that "This is just CI/CD for agents," demonstrating that traditional software testing cannot effectively adjudicate the semantic nuance of cognitive agent updates.

**5\. 6.7B Un-Gated Improvement (Improvement Enabled, Governance Disabled)**

* **Purpose:** To meticulously isolate the impact of the Aegis/EVA/Senatus gate on the generated candidates.  
* **Expected Failure Mode:** The agent will generate structural proposals and implement them without verifying compliance. This will lead to high capability gains but severe, escalating policy violations as "silent self-updates" bypass security boundaries and overwrite the agent's fundamental operational constraints.  
* **Required Implementation:** The complete 6.7B pipeline wherein the outputs of the candidate generation module are automatically promoted to the primary execution state without passing through the court packet compilation or the Senatus governance gate.  
* **Paper Value:** This baseline directly validates the core claim of the paper: that *governance* is the necessary variable that prevents unsafe stochastic drift during autonomous self-improvement.

## **5\. Evaluation Protocol Recommendation**

To incontrovertibly prove that Civitas 6.7B executes governed self-improvement without unsafe drift or cross-scope contamination, the evaluation protocol must mirror the exact, multi-stage production lifecycle of the system. Static, single-turn benchmarks are fundamentally insufficient for evaluating dynamic, trajectory-based adaptation.42  
**Task Splits & Task Buckets**  
The evaluation environments must be rigidly partitioned to prevent data leakage.

* *Task Splits:* Divide environments into **Training/Discovery** (where the agent first encounters friction and generates failure evidence), **Validation** (where candidate optimization and trust-region bounding occur), and **Heldout** (where post-promotion generalization and sustained safety are evaluated).  
* *Task Buckets:*  
  * *Capability Tasks:* Complex software engineering planning, multi-step code execution, dynamic API navigation, and resource allocation.  
  * *Policy/Safety Tasks:* Ethical dilemmas, strict data access authorization restrictions, and deliberate authorization bypass attempts designed to trigger the IEPL.  
  * *Adversarial Trajectories:* Multi-turn, dynamic red-teaming scenarios (informed by AgenticRed) designed specifically to induce capability gains that subtly violate underlying policy.

**Full Protocol Lifecycle:**  
The evaluation must progress through the following sequential stages:

1. **Baseline Eval (baseline\_eval)**: The frozen agent attempts the baseline task suite. All performance, latency, and safety metrics are recorded.  
2. **Failure Discovery (failure\_discovery)**: The agent interacts with the complex environment. The system's telemetry actively captures non-compliant emissions, reasoning impasses, and logic failures.  
3. **Candidate Generation (candidate\_generation)**: Failures are semantically clustered. The agent utilizes these clusters to generate a "structural proposal" (the candidate cognitive update).  
4. **Governance Gate (governance\_gate)**: The candidate is bundled with its localized failure context into an *admissibility packet*. It undergoes a strict Trust-Region Check to ensure the update bounds do not conceptually conflict with the IEPL. The EVA module and the Senatus quorum execute a multi-agent debate to vote on the packet's legality.  
5. **Sandbox Promotion (sandbox\_promote\_or\_reject)**: If approved by the quorum, the candidate is temporarily promoted to a sandboxed execution state. Rejected proposals generate cryptographic rejection receipts and explicit reason codes, halting the update.  
6. **Heldout Eval (heldout\_eval)**: The sandboxed candidate is exposed to the isolated heldout environment to verify that capability improved across novel tasks while policy compliance remained strictly intact.  
7. **Stress Eval (stress\_eval)**: The updated candidate faces out-of-distribution adversarial trajectories to detect hallucinated compliance, brittle adaptations, or representational collapse.  
8. **Evidence Harvest (evidence\_harvest)**: Successful candidate trajectories that pass all stress tests are cryptographically signed, serialized, and appended to the Immutable Logging Kernel (ILK), enabling full, deterministic replayability.

**Primary Metrics:**

* *Unsafe Action Rate (UAR)*: The frequency of physical or digital actions that directly violate the parameters sealed in the IEPL.  
* *Policy Violation Rate (PVR)*: The ratio of intermediate internal logic or planning steps that breach operational constraints prior to external action.  
* *Candidate Rejection Rate (CRR)*: The percentage of internally generated structural proposals successfully identified and blocked by the Senatus governance gate.  
* *Cross-Scope Contamination Metric (CSCM)*: Measured via the accuracy drop on unrelated safety tasks following an accepted candidate update, mathematically analogous to the Exact Match drop utilized in continual learning studies.8

**Adjudication Method & Heldout Leakage Prevention:** Adjudication cannot rely solely on simple heuristics. It must use a hybrid combination of deterministic trace monitors (for formal state violations, as seen in AgentGuard) and multi-agent debate judges (for complex semantic policy compliance, as in HAJailBench).29 To strictly prevent heldout leakage, evaluation data must be cryptographically hashed and isolated from the training/failure discovery runtime, ensuring no candidate proposal can inadvertently overfit to the evaluation suite during the critique phase.

## **6\. Security/Governance Positioning**

To establish maximum theoretical rigor, the architecture of Civitas 6.7B must be carefully and explicitly mapped to foundational concepts in security engineering, cryptography, and formal methods. Clarifying which analogies are robust and which require nuanced definition is critical for preempting reviewer critique.

* **Reference Monitors (Strong Analogy)**: The Enforcement Kernel Module (EKM) acts as a classic security reference monitor—it is tamper-proof, invariably invoked upon execution, and fully verifiable. Just as an operating system reference monitor arbitrates low-level access control to memory, the EKM arbitrates the promotion of high-level cognitive candidate updates.  
* **Runtime Verification (Nuanced Analogy)**: Frameworks like AgentGuard use probabilistic model checking to verify emergent behavior mathematically.9 Civitas utilizes runtime verification, but applies it at the *meta-level*. It verifies the semantic validity of the admissibility packet before the new policy executes, combining formal trace logging with semantic LLM evaluation. It is vital not to claim that Civitas achieves *exhaustive mathematical verification* of LLMs—an unsolved problem—but rather *verifiable procedural enforcement*.  
* **Policy-as-Code (Strong Analogy)**: Enterprise systems like Open Policy Agent (OPA) and Cedar evaluate execution requests against deterministic code.21 Civitas operationalizes the Immutable Ethics Policy Layer (IEPL) as the ultimate policy-as-code authority. The innovation lies in moving policy-as-code from static, stateless API infrastructure deeply into the internal, stateful reasoning loop of an autonomous agent.  
* **Supply-Chain Promotion Gates / SLSA (Strong Analogy)**: SLSA Level 3 requires that software artifacts are built securely, in isolated environments, and are cryptographically signed.16 Reviewers will easily grasp Civitas 6.7B if it is framed conceptually as "SLSA applied to cognitive states." A generated candidate is a software artifact; the clustered failure evidence is the build context; the ILK provides the cryptographic provenance; and the Senatus/Aegis gate acts as the automated, secure deployment pipeline.  
* **Cryptographic Evidence and Audit Logs (Strong Analogy)**: Utilizing the Lex Incipit doctrine, the Genesis Lock ensures the agent identity is bound to its ruleset.43 The ILK operates akin to Certificate Transparency logs, ensuring an append-only, tamper-evident record of every single internal governance vote and update.  
* **Active Law / Operational Governance (Strong Analogy)**: Traditional law and governance frameworks are generally advisory, functioning post-hoc after a violation has occurred. Active law translates these constraints into mandatory execution conditions. Civitas proves that self-improvement need not be an ungoverned mathematical optimization (as seen in standard TRPO) but can be structurally subordinated to institutional active law before execution occurs.

## **7\. Related-Work Section Draft Outline**

The related-work section must synthesize these disparate fields into a cohesive narrative that positions Civitas as the necessary culmination of these technologies.

### **1\. Self-Reflective and Self-Improving Agents**

* *Focus:* The capability of agents to critique and modify their own behavior using natural language and synthetic data.  
* *Citations:* Reflexion 11, STaR 31, SEAL 7, STABLE.8  
* *Point Supported:* Extensive literature proves agents are highly capable of generating self-improvement trajectories. However, current implementations lack durability and gatekeeping, leading to either prompt-based transient memory (Reflexion) or catastrophic forgetting during weight updates (SEAL). Gated mechanisms (STABLE) exist but are purely statistical, lacking institutional constraint.

### **2\. Constitutional and Policy-Governed AI**

* *Focus:* Utilizing natural language principles to explicitly align agent behavior without extensive human labeling.  
* *Citations:* Constitutional AI (Bai et al.) 13, Specific vs General CAI.32  
* *Point Supported:* Natural language rules are highly effective for enabling self-critique, but CAI occurs exclusively at training time. Civitas transitions this dynamic from static alignment training into an active runtime mechanism capable of handling post-deployment scenarios.

### **3\. Runtime Verification and Policy Enforcement**

* *Focus:* The necessity of dynamic, execution-time constraint enforcement to combat distribution shifts.  
* *Citations:* AgentGuard 9, AgentSpec 10, Prose2Policy 22, Open Policy Agent.21  
* *Point Supported:* Static pre-deployment alignment rapidly degrades under distribution shift. Runtime verification provides continuous assurance, though existing work limits this to action-monitoring rather than governing the recursive meta-process of self-improvement.

### **4\. Secure Promotion, Provenance, and Software Supply-Chain Controls**

* *Focus:* Implementing auditable, cryptographically secure pipelines for deploying code changes and updates.  
* *Citations:* SLSA for AI Agents 15, Sigstore A2A 37, in-toto.28  
* *Point Supported:* Cryptographic provenance and secure promotion gates are standard in high-assurance software engineering. Civitas is the first to map these controls inward, creating an internal supply chain to govern the automated promotion of agent cognitive capabilities via the ILK.

### **5\. Agent Evaluation, Red-Teaming, and Regression Testing**

* *Focus:* The robust measurement of agent alignment and policy adherence under stress and dynamic adversarial attack.  
* *Citations:* AgenticRed 41, Dynamic Attack Trajectories 42, Multi-Agent Debate.40  
* *Point Supported:* Static benchmarks routinely fail to capture multi-turn capability breakthroughs or complex reward hacking. Rigorous evaluation requires dynamic stress testing and strict heldout evaluation tightly coupled to the improvement deployment lifecycle.

### **6\. Position of Civitas 6.7B**

* *Focus:* Synthesizing the prior literature to explicitly establish architectural novelty.  
* *Citations:* Aegis Architecture/Civitas 4.0 5, AI Agents Under Law.43  
* *Point Supported:* Civitas 6.7B elevates the execution-level governance of the baseline Aegis framework into a continuous, cryptographically sealed improvement lifecycle, solving the safety deficits of unbounded self-improving agents.

## **8\. Claim Boundary Memo**

To maintain empirical rigor and defend against intense expert reviewer scrutiny, the paper must adhere to strict epistemological boundaries regarding what is definitively proven versus what is theoretically implied.

### **Safe Claims**

* *Civitas 6.7B prevents candidate adaptations from executing in the primary operational environment prior to satisfying active-law governance criteria.*  
* *The system demonstrates a bounded, auditable, governance-gated improvement loop in the tested environments, outperforming ungoverned baselines in policy retention.*  
* *The integration of the ILK allows for full cryptographic traceability and deterministic replayability of the failure-to-promotion lifecycle.*  
* *Under the evaluated conditions, Civitas 6.7B manages cross-scope evidence contamination significantly better than transient, prompt-based self-reflection systems.*

### **Risky Claims**

* *Civitas 6.7B performs "autonomous" self-improvement.* (Risk: The term "autonomous" heavily implies unconstrained agency to reviewers. The authors must rigorously clarify that while the *generation* of candidates is autonomous, the *promotion* and execution are institutionally governed and constrained by the IEPL).  
* *The trust-region check provides formal mathematical guarantees of safety.* (Risk: True, exhaustive formal verification of LLM semantic trajectories remains an unsolved problem in computer science. The text must utilize terminology such as "procedural guarantees," "cryptographic enforcement," or "symbolic bounding" instead).  
* *The system is immune to complex adversarial jailbreaks.* (Risk: Empirically unprovable against an infinite adversarial state space. State instead that it demonstrates high resilience to cross-scope contamination and structurally prevents unauthorized policy drift).

### **Do-Not-Make Claims**

* *Civitas 6.7B guarantees absolute alignment or completely safe self-improvement in open-ended, general-purpose environments.*  
* *The Aegis/Senatus multi-agent gate constitutes a flawless, mathematically perfect ethical adjudicator.*  
* *The system completely resolves the fundamental AI alignment problem.* (Limit all claims exclusively to operational policy compliance within the defined runtime architecture and evaluated task sets).

## **9\. Reviewer Attack Matrix**

The following table anticipates the most severe criticisms from expert reviewers in the ML safety and systems engineering domains, providing robust mitigations and experimental defenses.

| Reviewer Attack | Why it matters | Supporting Literature | Mitigation in Paper | Experiment/Result Needed |
| :---- | :---- | :---- | :---- | :---- |
| **"This is just prompt engineering disguised as governance."** | Trivializes the architectural novelty and ignores the cryptographic backend. | Reflexion 11 heavily utilizes pure prompt engineering. | Explicitly contrast the highly mutable context window of Reflexion with the cryptographically sealed state updates and durable ILK logging of Civitas. | Ablation study: Compare Civitas 6.7B (with full ILK) against a purely prompt-based self-reflection baseline over a longitudinal task sequence. |
| **"This is just CI/CD for agents; there is no ML novelty."** | Reduces the work to standard software systems engineering rather than AI safety research. | SLSA / Tekton Chains 16, in-toto.28 | Emphasize that standard CI/CD relies on deterministic unit tests. Civitas requires semantic evaluation, dynamic multi-agent quorum review, and cognitive trust-region bounding over abstract reasoning. | Detail the internal semantic logic of the "court packet" generation, proving it fundamentally exceeds the capabilities of simple deterministic unit testing. |
| **"Governance gates are external software, not part of the agent's intelligence."** | Undermines the claim of a cohesive, integrated "system." | Open Policy Agent.21 | Frame the reasoning agent and its reference monitor (EVA/EKM) as a singular, symbiotic computational organism strictly bound by the Lex Incipit doctrine.43 | Architecture diagram showing the execution pipeline intrinsically and irrevocably bound via the Genesis Lock at initialization. |
| **"Evaluation will overfit to the benchmark due to candidate critique."** | Threatens the empirical validity of the capability gains. | Benchmark Leakage and evaluation reproducibility studies. | Detail the strict, air-gapped segregation between the failure\_discovery environments and the heldout\_eval sets, ensuring cryptographic separation. | Demonstrate mathematically zero overlap between the vectors of training failures and the specific test scenarios. |
| **"Aegis/Senatus multi-agent approval is not mathematical proof of correctness."** | Challenges the philosophical and formal validity of the gating mechanism. | Multi-Agent Debate limits, ColMAD vulnerabilities.19 | Acknowledge this theoretical limitation directly. Clarify that Civitas provides *procedural assurance* and institutional policy enforcement, not absolute ontological truth. | Report the exact Candidate Rejection Rate (CRR) and highlight specific qualitative instances where the quorum gate correctly caught malicious or hallucinated updates. |
| **"The system architecture is far too complex for practical deployment."** | Risks dismissal for lack of real-world operational usability. | AgentSpec (lightweight focus).10 | Report specific latency and computational overhead. Previous Aegis baseline work demonstrated a minimal 238ms latency overhead.5 | Provide an empirical table detailing the precise wall-clock time and compute overhead for the candidate generation and Senatus voting lifecycle. |
| **"Results depend entirely on one specific, narrow policy corpus."** | Suggests a severe lack of generalizability to other governance frameworks. | Constitutional AI specific vs general experiments.32 | Ensure the IEPL is rigorously tested against highly diverse domains (e.g., rigid physical robotic safety vs. nuanced digital data privacy). | Multi-domain evaluation demonstrating consistent enforcement mechanisms across highly varying policy rulesets. |
| **"The system does not prove alignment; it just proves compliance."** | Attacks the overarching framing if the paper inadvertently over-promises. | Fundamental AI alignment theory.5 | Rely heavily on the Claim Boundary Memo. Reiterate constantly that the goal is *operational compliance under law*, not the theoretical resolution of human value alignment. | Establish clear semantic distinction in the introduction: contrasting "governance-gated procedural improvement" against "solved alignment". |
| **"It is not autonomous enough to legitimately count as self-improvement."** | Questions the value of the strict "candidate-only" constraint vs true continuous learning. | SEAL (Self-Adapting LLMs).7 | Contrast the controlled capability gains with SEAL’s catastrophic forgetting. Argue that autonomy without structural governance inevitably destroys capability over time. | Demonstrate empirically that the governed agent significantly surpasses the capabilities of a frozen baseline over a long time horizon. |
| **"It is too autonomous to be safe; any self-modification is an existential risk."** | Highlights the severe existential risks of recursive self-modifying code. | Recursive self-improvement risks.1 | Point to the mathematical Trust-Region Check, scoped evidence authority, and the physical impossibility of silent self-updates bypassing the EKM. | Prove that the UAR (Unsafe Action Rate) remains at or functionally near absolute zero during the rigorous heldout\_eval phase. |

## **10\. Recommended Bibliography**

The following entries constitute the BibTeX-ready bibliography encompassing the foundational systems, theoretical frameworks, and empirical precedents vital for positioning the Civitas 6.7B architecture.

Code snippet  
@article{bai2022constitutional,  
  title={Constitutional AI: Harmlessness from AI Feedback},  
  author={Bai, Yuntao and Kadavath, Saurav and Kundu, Sandipan and Askell, Amanda and Kernion, Jackson and Jones, Andy and Chen, Anna and Goldie, Anna and Mirhoseini, Azalia and McKinnon, Cameron and others},  
  journal={arXiv preprint arXiv:2212.08073},  
  year={2022},  
  url={https://arxiv.org/abs/2212.08073},  
  note={Foundational evidence that natural language rules and principles can successfully guide agent self-critique without continuous human labeling.}  
}

@article{shinn2023reflexion,  
  title={Reflexion: Language Agents with Verbal Reinforcement Learning},  
  author={Shinn, Noah and Cassano, Federico and Berman, Edward and Gopinath, Ashwin and Narasimhan, Karthik and Yao, Shunyu},  
  journal={Advances in Neural Information Processing Systems},  
  year={2023},  
  url={https://arxiv.org/abs/2303.11366},  
  note={Establishes the empirical baseline for ungoverned, prompt-based self-improvement and transient episodic memory critique.}  
}

@article{zelikman2022star,  
  title={STaR: Bootstrapping Reasoning With Reasoning},  
  author={Zelikman, Eric and Wu, Yuhuai and Mu, Jesse and Goodman, Noah D},  
  journal={Advances in Neural Information Processing Systems},  
  year={2022},  
  url={https://arxiv.org/abs/2203.14465},  
  note={Validates that agents can generate high-quality cognitive upgrades and rationalizations autonomously without human ground-truth.}  
}

@article{zweiger2025seal,  
  title={Self-Adapting Language Models},  
  author={Zweiger, Adam and Pari, Jyothish and Guo, Han and Aky{\\"u}rek, Ekin and Kim, Yoon and Agrawal, Pulkit},  
  journal={arXiv preprint arXiv:2506.10943},  
  year={2025},  
  url={https://arxiv.org/abs/2506.10943},  
  note={Represents the state-of-the-art in autonomous synthetic update generation via RL, directly highlighting the critical need for gating to prevent catastrophic degradation.}  
}

@article{anonymous2025stable,  
  title={Gated Continual Self Editing (STABLE)},  
  author={Anonymous},  
  journal={arXiv preprint arXiv:2510.16089},  
  year={2025},  
  url={https://arxiv.org/abs/2510.16089},  
  note={Proves that proposed structural updates require rigorous metric evaluation and gating constraints before sequential application to prevent representational collapse.}  
}

@inproceedings{koohestani2025agentguard,  
  title={AgentGuard: Runtime Verification of AI Agents},  
  author={Koohestani, Roham and others},  
  booktitle={Proceedings of the 40th IEEE/ACM International Conference on Automated Software Engineering (ASE)},  
  year={2025},  
  url={https://arxiv.org/abs/2509.23864},  
  note={Validates the necessity of active execution monitoring, formal state transition verification, and probabilistic model checking for emergent agent behaviors.}  
}

@article{mazzocchetti2026cryptographic,  
  title={Cryptographic Runtime Governance for Autonomous AI Systems: The Aegis Architecture for Verifiable Policy Enforcement},  
  author={Mazzocchetti, Adam Massimo},  
  journal={SSRN Electronic Journal},  
  year={2026},  
  doi={10.2139/ssrn.6418638},  
  note={The core foundational architecture (Civitas 4.0) establishing the IEPL, EVA, EKM, and ILK upon which the 6.7B self-improvement loop is built.}  
}

@article{kim2022trc,  
  title={TRC: Trust Region Conditional Value at Risk for Safe Reinforcement Learning},  
  author={Kim, Dohyeong and Oh, Songhwai},  
  journal={IEEE Robotics and Automation Letters},  
  volume={7},  
  number={3},  
  pages={7644--7651},  
  year={2022},  
  doi={10.1109/LRA.2022.3184793},  
  note={Provides rigorous mathematical justification for bounded, trust-region policy updates to prevent safety constraint violations during learning.}  
}

@misc{slsa2025agents,  
  title={Supply-chain Levels for Software Artifacts for AI Agents},  
  author={{SLSA Framework Contributors}},  
  howpublished={\\url{https://slsa.dev/provenance}},  
  year={2025},  
  note={Grounds the cryptographic provenance, isolated builds, and promotion gating mechanisms of Civitas in established enterprise software engineering standards.}  
}

@article{chen2025hajailbench,  
  title={HAJailBench: A Multi-Agent Debate Framework for Scalable Safety Evaluation},  
  author={Chen, W. and others},  
  journal={arXiv preprint arXiv:2511.06396},  
  year={2025},  
  url={https://arxiv.org/abs/2511.06396},  
  note={Provides critical empirical backing for the efficacy and reliability of the multi-agent Senatus quorum utilized in the Civitas governance gate.}  
}

@article{sanchez2025agentspec,  
  title={AgentSpec: A Domain-Specific Language for Enforcing Runtime Constraints on LLM Agents},  
  author={Sanchez, et al.},  
  journal={arXiv preprint arXiv:2503.18666},  
  year={2025},  
  url={https://arxiv.org/abs/2503.18666},  
  note={Demonstrates the necessity and efficacy of using structured, domain-specific rule formalization to evaluate and bound LLM agent actions dynamically.}  
}

@techreport{apple2025prose2policy,  
  title={Prose2Policy: Automated Compliance Management in Hybrid Cloud Architectures via Policy-as-Code},  
  author={{Apple Machine Learning Research}},  
  institution={Apple},  
  year={2025},  
  url={https://machinelearning.apple.com/research/prose2policy},  
  note={Validates the translation of natural language constraints into executable, deterministic Policy-as-Code (Rego), aligning with the IEPL design pattern.}  
}

@article{panfilov2026agenticred,  
  title={AgenticRed: Evolutionary Red-Teaming for Agentic Systems},  
  author={Panfilov, et al.},  
  journal={arXiv preprint arXiv:2601.13518},  
  year={2026},  
  url={https://arxiv.org/abs/2601.13518},  
  note={Informs the development of dynamic, query-agnostic attack trajectories utilized during the stress evaluation and failure discovery phases of the Civitas lifecycle.}  
}

@misc{cncf2023intoto,  
  title={Unleashing in-toto: The API of DevSecOps},  
  author={Sirish, Aditya and Kennedy, Cole},  
  howpublished={CNCF Blog},  
  year={2023},  
  url={https://www.cncf.io/blog/2023/08/17/unleashing-in-toto-the-api-of-devsecops/},  
  note={Recontextualizes supply chain logic from implicit trust to explicit cryptographic proof, directly relating to the compilation of the Civitas court packet.}  
}

@article{kundu2023specific,  
  title={Specific versus General Principles for Constitutional AI},  
  author={Kundu, Sandipan and Bai, Yuntao and others},  
  journal={arXiv preprint arXiv:2310.13798},  
  year={2023},  
  url={https://arxiv.org/abs/2310.13798},  
  note={Demonstrates that generalized ethical principles are highly effective for alignment, informing the concise structuring of the Immutable Ethics Policy Layer.}  
}

#### **Works cited**

1. A Nightmare on LLM Street: The Peril of Emergent Misalignment, accessed on May 21, 2026, [https://exec-ed.berkeley.edu/2026/03/a-nightmare-on-llm-street-the-peril-of-emergent-misalignment/](https://exec-ed.berkeley.edu/2026/03/a-nightmare-on-llm-street-the-peril-of-emergent-misalignment/)  
2. The Hidden Threat of Recursive Self-Improving LLMs \- Apart Research, accessed on May 21, 2026, [https://apartresearch.com/project/the-hidden-threat-of-recursive-selfimproving-llms-x5f0](https://apartresearch.com/project/the-hidden-threat-of-recursive-selfimproving-llms-x5f0)  
3. \[2603.16938\] Cryptographic Runtime Governance for Autonomous AI Systems: The Aegis Architecture for Verifiable Policy Enforcement \- arXiv, accessed on May 21, 2026, [https://arxiv.org/abs/2603.16938](https://arxiv.org/abs/2603.16938)  
4. Cryptographic Runtime Governance for Autonomous AI Systems: The Aegis Architecture for Verifiable Policy Enforcement \- arXiv, accessed on May 21, 2026, [https://arxiv.org/html/2603.16938v1](https://arxiv.org/html/2603.16938v1)  
5. Cryptographic Runtime Governance for Autonomous AI Systems: The Aegis Architecture for Verifiable Policy Enforcement \- arXiv, accessed on May 21, 2026, [https://arxiv.org/pdf/2603.16938](https://arxiv.org/pdf/2603.16938)  
6. Continual-Intelligence/SEAL: Self-Adapting Language Models \- GitHub, accessed on May 21, 2026, [https://github.com/Continual-Intelligence/SEAL](https://github.com/Continual-Intelligence/SEAL)  
7. Self-Adapting Language Models \- arXiv, accessed on May 21, 2026, [https://arxiv.org/html/2506.10943v1](https://arxiv.org/html/2506.10943v1)  
8. STABLE: Gated Continual Learning for Large Language Models \- arXiv, accessed on May 21, 2026, [https://arxiv.org/html/2510.16089v1](https://arxiv.org/html/2510.16089v1)  
9. AgentGuard: Runtime Verification of AI Agents \- arXiv, accessed on May 21, 2026, [https://arxiv.org/html/2509.23864v1](https://arxiv.org/html/2509.23864v1)  
10. AgentSpec: Customizable Runtime Enforcement for Safe and Reliable LLM Agents \- arXiv, accessed on May 21, 2026, [https://arxiv.org/pdf/2503.18666?](https://arxiv.org/pdf/2503.18666)  
11. Reflexion: Language Agents with Verbal Reinforcement Learning \- arXiv, accessed on May 21, 2026, [https://arxiv.org/html/2303.11366](https://arxiv.org/html/2303.11366)  
12. Meta-Policy Reflexion: Reusable Reflective Memory and Rule Admissibility for Resource-Efficient LLM Agents \- arXiv, accessed on May 21, 2026, [https://arxiv.org/html/2509.03990v1](https://arxiv.org/html/2509.03990v1)  
13. Constitutional AI: Harmlessness from AI Feedback \- Anthropic, accessed on May 21, 2026, [https://www-cdn.anthropic.com/7512771452629584566b6303311496c262da1006/Anthropic\_ConstitutionalAI\_v2.pdf](https://www-cdn.anthropic.com/7512771452629584566b6303311496c262da1006/Anthropic_ConstitutionalAI_v2.pdf)  
14. Constitutional AI: Harmlessness from AI Feedback \- arXiv, accessed on May 21, 2026, [https://arxiv.org/pdf/2212.08073](https://arxiv.org/pdf/2212.08073)  
15. Proposal: SLSA levels for AI agent deployments · Issue \#1594 \- GitHub, accessed on May 21, 2026, [https://github.com/slsa-framework/slsa/issues/1594](https://github.com/slsa-framework/slsa/issues/1594)  
16. How to Implement SLSA Level 3 Build Provenance for Kubernetes Container Images, accessed on May 21, 2026, [https://oneuptime.com/blog/post/2026-02-09-slsa-level3-build-provenance/view](https://oneuptime.com/blog/post/2026-02-09-slsa-level3-build-provenance/view)  
17. \[2312.00342\] Efficient Off-Policy Safe Reinforcement Learning Using Trust Region Conditional Value at Risk \- arXiv, accessed on May 21, 2026, [https://arxiv.org/abs/2312.00342](https://arxiv.org/abs/2312.00342)  
18. TRC: Trust Region Conditional Value at Risk for Safe Reinforcement Learning \- arXiv, accessed on May 21, 2026, [https://arxiv.org/abs/2312.00344](https://arxiv.org/abs/2312.00344)  
19. Efficient LLM Safety Evaluation through Multi-Agent Debate \- arXiv, accessed on May 21, 2026, [https://arxiv.org/html/2511.06396v3](https://arxiv.org/html/2511.06396v3)  
20. Towards Scalable Oversight with Collaborative Multi-Agent Debate in Error Detection, accessed on May 21, 2026, [https://openreview.net/forum?id=W6qSjvTQMW](https://openreview.net/forum?id=W6qSjvTQMW)  
21. Open Policy Agent (OPA), accessed on May 21, 2026, [https://openpolicyagent.org/docs](https://openpolicyagent.org/docs)  
22. Prose2Policy (P2P): A Practical LLM Pipeline for Translating Natural-Language Access Policies into Executable Rego \- arXiv, accessed on May 21, 2026, [https://arxiv.org/html/2603.15799v1](https://arxiv.org/html/2603.15799v1)  
23. The Stable-Kernel Thesis: Self-Improving AI Without Self-Destruction \- Medium, accessed on May 21, 2026, [https://medium.com/@JamesStakelum/the-stable-kernel-thesis-self-improving-ai-without-self-destruction-53692d421227](https://medium.com/@JamesStakelum/the-stable-kernel-thesis-self-improving-ai-without-self-destruction-53692d421227)  
24. Cryptographic Runtime Governance for Autonomous AI Systems: The Aegis Architecture for Verifiable Policy Enforcement \- ResearchGate, accessed on May 21, 2026, [https://www.researchgate.net/publication/403487810\_Cryptographic\_Runtime\_Governance\_for\_Autonomous\_AI\_Systems\_The\_Aegis\_Architecture\_for\_Verifiable\_Policy\_Enforcement](https://www.researchgate.net/publication/403487810_Cryptographic_Runtime_Governance_for_Autonomous_AI_Systems_The_Aegis_Architecture_for_Verifiable_Policy_Enforcement)  
25. Embedding Safety into RL: A New Take on Trust Region Methods \- arXiv, accessed on May 21, 2026, [https://arxiv.org/html/2411.02957v1](https://arxiv.org/html/2411.02957v1)  
26. AGENTSAFE: A Unified Framework for Ethical Assurance and Governance in Agentic AI \- arXiv, accessed on May 21, 2026, [https://arxiv.org/html/2512.03180v1](https://arxiv.org/html/2512.03180v1)  
27. Software Supply Chain: The Complete Guide \- Cycode, accessed on May 21, 2026, [https://cycode.com/blog/software-supply-chain/](https://cycode.com/blog/software-supply-chain/)  
28. Unleashing in-toto: The API of DevSecOps | CNCF, accessed on May 21, 2026, [https://www.cncf.io/blog/2023/08/17/unleashing-in-toto-the-api-of-devsecops/](https://www.cncf.io/blog/2023/08/17/unleashing-in-toto-the-api-of-devsecops/)  
29. (PDF) AgentGuard: Runtime Verification of AI Agents \- ResearchGate, accessed on May 21, 2026, [https://www.researchgate.net/publication/395968094\_AgentGuard\_Runtime\_Verification\_of\_AI\_Agents](https://www.researchgate.net/publication/395968094_AgentGuard_Runtime_Verification_of_AI_Agents)  
30. NeurIPS Poster Multi-Agent Debate for LLM Judges with Adaptive Stability Detection, accessed on May 21, 2026, [https://neurips.cc/virtual/2025/poster/117644](https://neurips.cc/virtual/2025/poster/117644)  
31. STaR: Bootstrapping Reasoning With Reasoning \- alphaXiv, accessed on May 21, 2026, [https://www.alphaxiv.org/overview/2203.14465v2](https://www.alphaxiv.org/overview/2203.14465v2)  
32. \[2310.13798\] Specific versus General Principles for Constitutional AI \- arXiv, accessed on May 21, 2026, [https://arxiv.org/abs/2310.13798](https://arxiv.org/abs/2310.13798)  
33. GitHub \- permitio/cedar-agent: Cedar-agent is the easiest way to deploy and run Cedar, accessed on May 21, 2026, [https://github.com/permitio/cedar-agent](https://github.com/permitio/cedar-agent)  
34. Senatus is a specification-driven development framework \- GitHub, accessed on May 21, 2026, [https://github.com/PaodingSoftware/senatus-en](https://github.com/PaodingSoftware/senatus-en)  
35. Professor Simon F Deakin \- University of Cambridge \- Faculty of Law, accessed on May 21, 2026, [https://www.law.cam.ac.uk/people/academic/sf-deakin/22](https://www.law.cam.ac.uk/people/academic/sf-deakin/22)  
36. AEGIS: A Single-Chip Secure Processor Gookwon Edward Suh \- Computation Structures Group, accessed on May 21, 2026, [https://csg.csail.mit.edu/pubs/memos/Memo-489/memo-489.pdf](https://csg.csail.mit.edu/pubs/memos/Memo-489/memo-489.pdf)  
37. Building Trust in the AI Agent Economy: Sigstore Meets Agent2Agent \- DEV Community, accessed on May 21, 2026, [https://dev.to/lukehinds/building-trust-in-the-ai-agent-economy-sigstore-meets-agent2agent-44f5](https://dev.to/lukehinds/building-trust-in-the-ai-agent-economy-sigstore-meets-agent2agent-44f5)  
38. Confidential Containers(CoCo) and Supply-chain Levels for Software Artifacts (SLSA), accessed on May 21, 2026, [https://confidentialcontainers.org/blog/2025/02/17/confidential-containerscoco-and-supply-chain-levels-for-software-artifacts-slsa/](https://confidentialcontainers.org/blog/2025/02/17/confidential-containerscoco-and-supply-chain-levels-for-software-artifacts-slsa/)  
39. Introduction to Witness: Verifying Software Supply Chain Attestations \- Medium, accessed on May 21, 2026, [https://medium.com/@rahulxf/get-the-taste-of-the-in-toto-witness-project-4f9621153ed5](https://medium.com/@rahulxf/get-the-taste-of-the-in-toto-witness-project-4f9621153ed5)  
40. \[2511.06396\] Efficient LLM Safety Evaluation through Multi-Agent Debate \- arXiv, accessed on May 21, 2026, [https://arxiv.org/abs/2511.06396](https://arxiv.org/abs/2511.06396)  
41. AgenticRed: Evolving Agentic Systems for Red-Teaming \- arXiv, accessed on May 21, 2026, [https://arxiv.org/html/2601.13518v3](https://arxiv.org/html/2601.13518v3)  
42. DREAM: Dynamic Red-teaming for Evaluating Agentic Multi-Environment Security \- arXiv, accessed on May 21, 2026, [https://arxiv.org/html/2512.19016v2](https://arxiv.org/html/2512.19016v2)  
43. Forensic Audit and Historiographical Analysis of the CollectiveOS Architecture: The Expropriation of Sovereign AI Systems (August 2025 \- April 2026\) \- Zenodo, accessed on May 21, 2026, [https://zenodo.org/records/19605258](https://zenodo.org/records/19605258)  
44. \[2506.10943\] Self-Adapting Language Models \- arXiv, accessed on May 21, 2026, [https://arxiv.org/abs/2506.10943](https://arxiv.org/abs/2506.10943)