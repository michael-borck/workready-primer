// ============================================================================
// WorkReady — Interactive Fiction Primer
// An internship simulation covering six stages of the intern journey.
// Built with Ink (inkle) for browser playback via inkjs.
// ============================================================================
//
// MAINTAINER NOTE — TONE VARIANTS:
// This file uses three parallel narrative tones (1=warm, 2=professional,
// 3=playful) selected by the player on the title screen. Most narrative
// content is wrapped in `{tone: -1: ... -2: ... -3: ...}` blocks.
// When editing ANY narrative content, update ALL THREE variants together
// to keep the voices in sync. Score callouts (like `[Readiness +2]`)
// are gated by `{tone == 3: ...}` and only appear in playful mode.
//
// MAINTAINER NOTE — SHADOW PATHS:
// After each major decision, a `shadow_after_stageN` knot shows the
// player what would have happened if they'd picked the alternative.
// This is the primer's pedagogical core — preserve it when editing.
//
// MAINTAINER NOTE — BUILD:
// After editing this file, the workready.ink.json output must be
// regenerated. The pre-commit hook (.githooks/pre-commit) does this
// automatically when you `git commit`. To rebuild manually: ./build.sh
//
// ============================================================================

// --- State Variables ---

VAR tone = 0                          // 1 = warm, 2 = professional, 3 = playful
VAR readiness_score = 0
VAR confidence = 50
VAR resume_quality = 0
VAR relationship_with_manager = 0
VAR relationship_with_colleagues = 0
VAR asked_for_help = false
VAR reading_the_room = 0

// Tracking variables for narrative callbacks
VAR chosen_company = ""
VAR chosen_role = ""
VAR manager_name = ""                 // set per-company in board_choice
VAR rushed_application = false
VAR got_interview = true              // false only if resume_quality < 2 in Stage 3
VAR chose_to_reschedule = false

// Per-stage choice tracking (used by shadow paths to surface alternatives)
VAR stage4_choice = 0                 // 1=wait, 2=interrupt, 3=colleague
VAR stage5_choice = 0                 // 1=join, 2=wave, 3=leave
VAR stage6_choice = 0                 // 1=accept, 2=defensive, 3=specifics

// --- Entry Point ---
-> title_screen


// ============================================================================
// TITLE SCREEN
// ============================================================================

=== title_screen ===

// Reset all state (needed for replay)
~ readiness_score = 0
~ confidence = 50
~ resume_quality = 0
~ relationship_with_manager = 0
~ relationship_with_colleagues = 0
~ asked_for_help = false
~ reading_the_room = 0
~ chosen_company = ""
~ chosen_role = ""
~ manager_name = ""
~ rushed_application = false
~ got_interview = true
~ chose_to_reschedule = false
~ stage4_choice = 0
~ stage5_choice = 0
~ stage6_choice = 0
~ tone = 0

# CLEAR
# layout:tone-select
# bg: title
# char: none

Welcome to <b>WorkReady</b>.

You're about to experience an internship from start to finish — six stages, from scanning the job board to your final exit interview.

Every choice you make shapes what happens next. Some paths only open if you've built enough confidence or made the right connections along the way.

Before we begin, choose how you'd like the story told:

+ [Warm & Encouraging]
    ~ tone = 1
    -> tone_confirm
+ [Professional]
    ~ tone = 2
    -> tone_confirm
+ [Playful & Gamified]
    ~ tone = 3
    -> tone_confirm


=== tone_confirm ===

{tone:
- 1: Great choice. Think of me as a friend who's been through this before — someone in your corner. I'll guide you through each stage, and we'll figure it out together. Ready?
- 2: Understood. This simulation will walk you through each stage of an internship placement in a realistic workplace context. Your decisions will have professional consequences.
- 3: MODE SELECTED: <b>Playful</b>. Achievement unlocked: "Ready Player Intern" 🎮. Your Readiness Score starts at zero. Every choice earns — or costs — you points. Let's see what you're made of.
}

+ [Let's begin]
    -> scanning_the_board


// ============================================================================
// STAGE 1: SCANNING THE BOARD
// ============================================================================

=== scanning_the_board ===

# CLEAR
# layout:job-board
# bg: job_board
# char: none

{tone:
- 1: You walk up to the WorkReady Jobs board and take a deep breath. There's a lot here — six different organisations, each offering something different. Don't rush. Have a look around.
- 2: The WorkReady Jobs board displays current internship vacancies across six Perth-based organisations. Each listing includes the company name, sector, and available role.
- 3: 🎯 <b>STAGE 1: THE JOB BOARD</b>. Six companies. Six roles. One you. Scan the board and pick your quest!
}

// The job listings are rendered as cards by the player when the
// `layout:job-board` knot tag (above) is present. The card metadata
// (sector, icon, tagline) lives in the JOB_CARDS lookup table in
// index.html, keyed by company name. The renderer parses each choice's
// text ("Role — Company") to find the matching card data.
//
// To add a new company: add a choice here AND a corresponding entry to
// JOB_CARDS in index.html.

+ [Junior Data Analyst — NexusPoint Systems]
    ~ chosen_company = "NexusPoint Systems"
    ~ chosen_role = "Junior Data Analyst"
    ~ manager_name = "Priya"
    -> board_choice
+ [Operations Support Intern — IronVale Resources]
    ~ chosen_company = "IronVale Resources"
    ~ chosen_role = "Operations Support Intern"
    ~ manager_name = "Dale"
    -> board_choice
+ [Graduate Consulting Analyst — Meridian Advisory]
    ~ chosen_company = "Meridian Advisory"
    ~ chosen_role = "Graduate Consulting Analyst"
    ~ manager_name = "Eleanor"
    -> board_choice
+ [Policy & Research Intern — Metro Council WA]
    ~ chosen_company = "Metro Council WA"
    ~ chosen_role = "Policy & Research Intern"
    ~ manager_name = "Margaret"
    -> board_choice
+ [Client Services Intern — Southern Cross Financial]
    ~ chosen_company = "Southern Cross Financial"
    ~ chosen_role = "Client Services Intern"
    ~ manager_name = "James"
    -> board_choice
+ [Community Programs Intern — Horizon Foundation]
    ~ chosen_company = "Horizon Foundation"
    ~ chosen_role = "Community Programs Intern"
    ~ manager_name = "Kim"
    -> board_choice


=== board_choice ===

{tone:
- 1: Nice pick! {chosen_company} — that could be a really great fit. But here's the thing...
- 2: You have selected {chosen_role} at {chosen_company}. However, there is a complication.
- 3: Quest accepted: <b>{chosen_role}</b> at <b>{chosen_company}</b>! But wait — plot twist incoming...
}

You check the deadline. Applications close in <b>two hours</b>.

Your resume isn't tailored to this role. You have a generic version saved, but it doesn't mention anything specific to {chosen_company} or the {chosen_role} position.

{tone:
- 1: Two hours isn't much. What do you want to do?
- 2: You must decide how to proceed within the time constraint.
- 3: ⏰ THE CLOCK IS TICKING! What's your move?
}

+ [Rush it — submit my generic resume now]
    ~ rushed_application = true
    ~ confidence = confidence - 5
    {tone:
    - 1: Okay — sometimes you've got to go for it. You hit submit with your heart pounding. It's done. But that nagging feeling that you could have done more? That's worth remembering.
    - 2: You submit the generic resume. The application is lodged within the deadline. However, the resume does not address the specific requirements of the role.
    - 3: SPEED RUN! 💨 Resume submitted. But it's... generic. The recruiter might notice. Confidence -5.
    }
    ~ readiness_score = readiness_score + 1
    {tone == 3: <i>[Readiness +1 · Total: {readiness_score}]</i>}
    -> shadow_after_stage1

+ [Wait — I'll miss this one but prepare properly for the next round]
    ~ rushed_application = false
    ~ confidence = confidence + 5
    {tone:
    - 1: Smart call. It's hard to let one go, but you'll be in a much stronger position next time. The {chosen_role} role at {chosen_company} comes around again in the next intake, and this time you'll be ready.
    - 2: You allow the deadline to pass. The same role is listed again in the next intake cycle, giving you time to prepare a targeted application.
    - 3: PATIENCE UNLOCKED! 🧘 You let this one go. The same role reappears next intake. Confidence +5. Smart play.
    }
    ~ readiness_score = readiness_score + 2
    {tone == 3: <i>[Readiness +2 · Total: {readiness_score}]</i>}
    -> shadow_after_stage1


=== shadow_after_stage1 ===

{tone:
- 1: Before we move on — let's take a quick peek at what would have happened if you'd chosen the other path.
- 2: <b>Path-not-taken — alternative outcome:</b>
- 3: 🔮 ALT TIMELINE PEEK!
}

{rushed_application:
    {tone:
    - 1: If you'd waited, you'd have missed this specific role — but you'd have had time to research {chosen_company} properly and tailor a stronger application for the next intake. Sometimes patience pays.
    - 2: Had you waited, this listing would have closed without your application. However, the role reopens next intake, allowing for a more competitive submission with proper preparation.
    - 3: 🔮 If you'd WAITED: missed this quest, but next intake = stronger app + Confidence +5. Patience meta unlocks late game.
    }
- else:
    {tone:
    - 1: If you'd rushed it, you'd have submitted a generic resume. The recruiter would have flagged it as untailored, and your confidence would have taken a knock for ignoring that nagging feeling.
    - 2: Had you rushed, you would have submitted a generic application unlikely to clear initial screening, with a corresponding hit to confidence.
    - 3: 🔮 If you'd RUSHED: generic resume, recruiter side-eye, Confidence -5. Speed kills.
    }
}

+ [Move on to Stage 2]
    -> submitting_the_resume


// ============================================================================
// STAGE 2: SUBMITTING THE RESUME
// ============================================================================

=== submitting_the_resume ===

# CLEAR
# bg: desk
# char: none

{tone:
- 1: Alright — Stage 2. This is where you put yourself on paper. A good resume doesn't just list what you've done. It tells the reader why you're right for <i>this</i> role.
- 2: <b>Stage 2: Resume Submission.</b> You are preparing your application for the {chosen_role} position at {chosen_company}. The quality of your resume will determine whether you are invited to interview.
- 3: 📝 <b>STAGE 2: THE RESUME</b>. Time to craft your character sheet! What do you lead with?
}

{rushed_application:
    Your generic resume is already submitted, but {chosen_company} allows applicants to update their materials before the review date. You have a second chance to improve it.
- else:
    You have time to build a strong, tailored resume from scratch. What do you want to lead with?
}

+ [Lead with academic results and GPA]
    ~ resume_quality = resume_quality + 1
    {tone:
    - 1: Solid foundation! Your grades show you can do the work. Though on its own, every applicant leads with grades — you might not stand out just yet.
    - 2: Academic credentials are included. This demonstrates baseline competence but does not differentiate you from other applicants.
    - 3: 📊 GPA loaded! It's a safe play — reliable but not flashy.
    }
    {tone == 3: <i>[Resume Quality +1]</i>}
    -> resume_second_choice

+ [Lead with skills relevant to the role]
    ~ resume_quality = resume_quality + 2
    {tone:
    - 1: That's the way. You've looked at what {chosen_company} actually needs and matched your skills to it. That shows initiative — and recruiters notice.
    - 2: Role-relevant skills are highlighted. This directly addresses the selection criteria and demonstrates you have researched the position.
    - 3: 🎯 Direct hit! You matched your skills to the job ad. Recruiters love that.
    }
    {tone == 3: <i>[Resume Quality +2]</i>}
    -> resume_second_choice

+ [Lead with personal interests and hobbies]
    ~ resume_quality = resume_quality + 1
    ~ confidence = confidence + 5
    {tone:
    - 1: There's something nice about showing who you are beyond the textbook. It makes you memorable. Just make sure the connection to the role is clear.
    - 2: Personal interests are included. While this adds personality to the application, it may not directly address the role requirements.
    - 3: 🎸 Going for the personality angle! Bold choice. Confidence +5 for being yourself.
    }
    {tone == 3: <i>[Resume Quality +1 · Confidence +5]</i>}
    -> resume_second_choice


=== resume_second_choice ===

{tone:
- 1: Good start. Now — do you want to add anything else before you submit?
- 2: You may add a second element to strengthen your application.
- 3: Round 2! Add another layer to your resume:
}

+ [Add a tailored cover letter]
    ~ resume_quality = resume_quality + 2
    {tone:
    - 1: A tailored cover letter can make all the difference. You take the time to explain why {chosen_company} matters to you — not just what you can do, but why you want to do it <i>here</i>.
    - 2: A cover letter is drafted addressing {chosen_company}'s specific needs and your motivation for the role. This significantly strengthens the application.
    - 3: ✍️ COVER LETTER CRAFTED! You explained why {chosen_company} is your top pick. Major bonus.
    }
    {tone == 3: <i>[Resume Quality +2]</i>}
    -> resume_outcome

+ [Add references from a previous employer]
    ~ resume_quality = resume_quality + 1
    {tone:
    - 1: References show you've got people who'll vouch for you. That counts for something.
    - 2: Professional references are included. This provides third-party validation of your work ethic and capabilities.
    - 3: 📞 References added. Someone out there will back you up!
    }
    {tone == 3: <i>[Resume Quality +1]</i>}
    -> resume_outcome

+ {confidence >= 55} [Add a short portfolio of relevant work]
    ~ resume_quality = resume_quality + 2
    {tone:
    - 1: Now that's impressive. You've put together a small portfolio that shows — not just tells — what you can do. The kind of thing that makes a recruiter pause and look twice.
    - 2: A portfolio of relevant work samples is attached. This provides concrete evidence of capability and is a strong differentiator.
    - 3: 💼 PORTFOLIO UNLOCKED! (Required Confidence ≥ 55) You showed your work. Massive advantage.
    }
    {tone == 3: <i>[Resume Quality +2]</i>}
    -> resume_outcome

+ [Submit as is — don't overthink it]
    {tone:
    - 1: Sometimes done is better than perfect. You hit submit and move on.
    - 2: No additional materials are added. The application is submitted in its current state.
    - 3: YOLO SUBMIT! 🚀 No extras. Let's see if it sticks.
    }
    -> resume_outcome


=== resume_outcome ===

~ readiness_score = readiness_score + 1

{resume_quality >= 4:
    {tone:
    - 1: Your application is strong. Really strong. You've shown {chosen_company} exactly who you are and why you belong there. Well done — that took effort, and it shows.
    - 2: Your application is comprehensive and well-targeted. Based on the quality of your materials, you are highly likely to receive an interview invitation.
    - 3: 🌟 RESUME QUALITY: EXCELLENT ({resume_quality}/6)! Interview practically guaranteed!
    }
    ~ readiness_score = readiness_score + 2
    {tone == 3: <i>[Readiness +3 total this stage · Total: {readiness_score}]</i>}
- else:
    {resume_quality >= 2:
        {tone:
        - 1: Solid work. Your resume might not blow anyone away, but it's honest and shows you've thought about the role. That puts you ahead of plenty of applicants.
        - 2: Your application meets the minimum standard for shortlisting. An interview invitation is probable but not certain.
        - 3: 📋 RESUME QUALITY: SOLID ({resume_quality}/6). You're in the running!
        }
        ~ readiness_score = readiness_score + 1
        {tone == 3: <i>[Readiness +2 total this stage · Total: {readiness_score}]</i>}
    - else:
        {tone:
        - 1: The resume is... fine. But fine might not be enough in a competitive field. Don't worry — there's always something to learn from this.
        - 2: Your application is below the expected standard for shortlisting. The resume lacks specificity and does not address the role requirements directly.
        - 3: 😬 RESUME QUALITY: WEAK ({resume_quality}/6). This might be a tough sell...
        }
        {tone == 3: <i>[Readiness +1 total this stage · Total: {readiness_score}]</i>}
    }
}

{tone:
- 1: Whatever you submitted, it's out of your hands now. The waiting begins.
- 2: The application is now under review. The next stage commences upon a response from {chosen_company}.
- 3: 📤 RESUME SUBMITTED. Now we wait. Loading next stage...
}

+ [Continue to Stage 3]
    -> attending_the_interview


// ============================================================================
// STAGE 3: ATTENDING THE INTERVIEW
// ============================================================================

=== attending_the_interview ===

# CLEAR
# bg: interview_room
# char: hiring_manager

{tone:
- 1: Stage 3. The interview. Deep breath — this is the part most people dread. But here's a secret: preparation matters more than perfection.
- 2: <b>Stage 3: The Interview.</b> {chosen_company} has reviewed your application and will now determine whether to proceed with an interview.
- 3: 🎤 <b>STAGE 3: THE INTERVIEW</b>. Boss battle incoming! (Or not, depending on that resume...)
}

// Gate: did the resume make the cut?
{resume_quality < 2:
    ~ got_interview = false
    {tone:
    - 1: A few days pass... and then the email arrives. "Thank you for your interest, but we've decided to progress other candidates." It stings. But it's not the end.
    - 2: You receive a standard rejection email. Your application did not meet the shortlisting threshold. This outcome reflects the quality of your submitted materials.
    - 3: 📧 REJECTED. Your resume didn't make the cut. Game over? Not quite...
    }

    {tone:
    - 1: Here's the thing about rejection — it teaches you something if you let it. You take a moment to look at your resume again, and this time you see the gaps. That awareness? That's growth.
    - 2: You review your application materials and identify areas for improvement. This reflective process, while uncomfortable, builds self-awareness that will strengthen future applications.
    - 3: 🔄 REFLECTION BONUS! You reviewed what went wrong. Experience gained!
    }

    ~ readiness_score = readiness_score + 1
    ~ confidence = confidence - 5
    {tone == 3: <i>[Readiness +1 (reflection) · Confidence -5 · Total: {readiness_score}]</i>}

    {tone:
    - 1: But the simulation continues — imagine you'd applied more carefully, and {chosen_company} called you in. What would you do next?
    - 2: For learning purposes, the simulation will now proceed as though you received an interview invitation.
    - 3: SECOND CHANCE ACTIVATED! Let's pretend that resume was better. The interview awaits!
    }

    -> interview_preparation

- else:
    {tone:
    - 1: Good news — your phone buzzes with an email from {chosen_company}. They want to meet you! The interview is scheduled for Thursday at 10 AM.
    - 2: You receive an interview invitation from {chosen_company}. The interview is scheduled for Thursday at 10:00 AM at their Perth CBD office.
    - 3: 📱 DING! Interview invite from {chosen_company}! Thursday, 10 AM. Quest continues!
    }

    -> interview_preparation
}


=== interview_preparation ===

{tone:
- 1: It's Wednesday evening. The interview is tomorrow morning. You'd planned to prepare tonight, but a friend called with a crisis and you spent the evening helping them. Now it's 11 PM and you haven't done any interview prep. You feel underprepared.
- 2: The evening before the interview, an unexpected personal commitment prevents your planned preparation. You are now underprepared with limited time remaining.
- 3: ⚡ PLOT TWIST! Your prep time vanished (friend emergency). It's 11 PM. Interview is at 10 AM. You are NOT ready.
}

What do you do?

+ [Go in anyway — I'll wing it]
    ~ confidence = confidence - 5
    {tone:
    - 1: Brave call. Maybe a little reckless, but sometimes you've just got to show up and be yourself. Let's see how it goes.
    - 2: You decide to attend without additional preparation. This carries risk but demonstrates commitment.
    - 3: 🎲 WINGING IT! Bold move. Let's roll the dice...
    }
    -> interview_questions

+ [Ask to reschedule]
    ~ chose_to_reschedule = true
    ~ confidence = confidence - 5
    ~ readiness_score = readiness_score + 1
    {tone:
    - 1: That takes courage too — admitting you're not ready and asking for more time. {chosen_company}'s HR responds the next morning: they can fit you in next Tuesday. You spend the weekend preparing properly.
    - 2: You contact {chosen_company} to request a rescheduling. HR accommodates with a new slot the following week. You use the additional time for structured preparation.
    - 3: 📅 RESCHEDULE REQUESTED! They moved it to next Tuesday. You spent the weekend cramming. Readiness +1!
    }
    ~ confidence = confidence + 10
    {tone == 3: <i>[Confidence: -5 then +10 (net +5) · Readiness +1 · Total: {readiness_score}]</i>}
    -> interview_questions


=== interview_questions ===

~ temp question_type = RANDOM(1, 3)

{tone:
- 1: You're sitting in the interview room. The hiring manager smiles, makes some small talk, and then asks their first real question:
- 2: The interview commences. After introductions, the hiring manager poses the following question:
- 3: 🎬 INTERVIEW START! The hiring manager leans forward and asks:
}

{question_type:
- 1:
    <i>"Tell me about a time you had to solve a problem under pressure. What did you do?"</i>
- 2:
    <i>"What specifically interests you about working in this sector? Why {chosen_company}?"</i>
- 3:
    <i>"How do you handle feedback that you disagree with?"</i>
}

+ [Give a rehearsed, textbook answer]
    ~ readiness_score = readiness_score + 1
    {tone:
    - 1: Your answer is... fine. Safe. The hiring manager nods politely but doesn't lean in. You can tell they've heard this kind of answer before.
    - 2: Your response is competent but generic. It does not differentiate you from other candidates. The interviewer notes your answer without follow-up questions.
    - 3: 📝 Safe answer delivered. The interviewer nods. It's... fine. Just fine.
    }
    {tone == 3: <i>[Readiness +1]</i>}
    -> interview_outcome

+ [Be honest — share a real experience, even if imperfect]
    ~ readiness_score = readiness_score + 2
    ~ confidence = confidence + 5
    {tone:
    - 1: You take a breath and tell them something real. It's not a polished story — you stumbled, you learned, you grew. The hiring manager's expression changes. They lean in. "That's interesting — tell me more."
    - 2: You provide an authentic, specific example. While the outcome wasn't perfect, your self-awareness and learning orientation are evident. The interviewer engages with follow-up questions.
    - 3: 💡 AUTHENTICITY BONUS! The interviewer actually leaned in. They asked follow-up questions. You stood out!
    }
    {tone == 3: <i>[Readiness +2 · Confidence +5]</i>}
    -> interview_outcome

+ [Freeze up — stumble through an unclear response]
    ~ confidence = confidence - 10
    {tone:
    - 1: The words don't come. You start a sentence, stop, start again. The hiring manager waits patiently, but you can feel the moment slipping. It's okay — this happens to everyone. What matters is what you do next.
    - 2: You are unable to articulate a clear response. The interviewer allows a pause but moves on to the next question. This has negatively impacted your presentation.
    - 3: 😰 FREEZE! Words.exe has stopped responding. Confidence -10. Ouch.
    }
    ~ readiness_score = readiness_score + 1
    {tone == 3: <i>[Readiness +1 (you still showed up) · Confidence -10]</i>}
    -> interview_outcome


=== interview_outcome ===

{chose_to_reschedule:
    {tone:
    - 1: Because you rescheduled and prepared, you handle the rest of the interview with much more composure. The extra time made a real difference.
    - 2: Your rescheduling decision proves effective. The additional preparation time results in a more confident and structured interview performance.
    - 3: 📈 PREP BONUS ACTIVE! Rescheduling paid off — you handled the rest with extra composure.
    }
    ~ readiness_score = readiness_score + 1
    {tone == 3: <i>[Readiness +1 (prep bonus)]</i>}
}

{tone:
- 1: The interview wraps up. Whatever happened in there, you showed up. That counts. The offer comes through a few days later — {chosen_company} wants you to start next Monday.
- 2: The interview concludes. {chosen_company} extends an offer for the internship position. Your start date is the following Monday.
- 3: 🎉 INTERVIEW COMPLETE! {chosen_company} sends an offer! You're in! Starting Monday!
}

~ readiness_score = readiness_score + 1
{tone == 3: <i>[Readiness +1 (completed interview) · Total: {readiness_score}]</i>}

+ [What if I'd handled the prep differently?]
    -> shadow_after_stage3


=== shadow_after_stage3 ===

{tone:
- 1: A glimpse at what the alternative might have looked like:
- 2: <b>Path-not-taken — alternative outcome:</b>
- 3: 🔮 ALT TIMELINE PEEK!
}

{chose_to_reschedule:
    {tone:
    - 1: If you'd gone in unprepared, you'd have walked in with the interview question still rattling around your head. You might have stumbled — confidence taking a hit — but you'd also have learned something about yourself under pressure.
    - 2: Had you proceeded without preparation, your performance would have been inconsistent and your confidence likely diminished. However, the experience of interviewing under-prepared has its own learning value.
    - 3: 🔮 If you'd WINGED IT: probable freeze, Confidence -10, but XP for surviving. Live to fight another day.
    }
- else:
    {tone:
    - 1: If you'd asked to reschedule, the hiring manager would likely have respected the honesty. You'd have lost a small amount of confidence in the moment, but gained a weekend of proper prep — and probably a much smoother interview the second time around.
    - 2: Had you requested rescheduling, the additional preparation time would have improved your interview performance and reflected self-awareness — typically valued by hiring managers.
    - 3: 🔮 If you'd RESCHEDULED: short-term Confidence -5, long-term Confidence +10, prep bonus active. Knowing when to pause = power.
    }
}

+ [Move on to Stage 4]
    -> completing_the_work_task


// ============================================================================
// STAGE 4: COMPLETING THE WORK TASK
// ============================================================================

=== completing_the_work_task ===

# CLEAR
# layout:approach-cards
# bg: office
# char: manager

{tone:
- 1: Stage 4. You've made it — you're actually here, at {chosen_company}, sitting at a real desk with a real login and a real manager who just handed you your first real task.
- 2: <b>Stage 4: The Work Task.</b> Your first week at {chosen_company}. Your line manager, {manager_name}, has assigned your first substantive task.
- 3: 💼 <b>STAGE 4: THE WORK TASK</b>. First week on the job! Your manager {manager_name} has a task for you. Let's see what you've got.
}

{tone:
- 1: {manager_name} seems busy — they're always in meetings or rushing between conversations. But they took the time to explain the task clearly before heading off to their next call: pull together a summary of recent project data and flag anything that looks unusual.
- 2: {manager_name} briefs you on the task: compile and summarise recent project data, flagging any anomalies. The deliverable is due by end of day Thursday. {manager_name} is visibly occupied with other commitments.
- 3: THE TASK: Compile project data, find anomalies, deliver summary by Thursday. {manager_name} drops the brief and vanishes into meetings. You're on your own... or are you?
}

You're halfway through when you hit a wall. The data format doesn't match what {manager_name} described. You can't tell if it's an error in the data or if you're misunderstanding the brief.

{manager_name} is in a meeting behind a closed door. A colleague, Sam, is working at the desk across from you.

{tone:
- 1: What do you do? There's no wrong answer here — but each path teaches you something different.
- 2: Select your approach to resolving this blocker.
- 3: ⚠️ BLOCKER! Choose your strategy:
}

+ [Wait for {manager_name} to finish the meeting]
    ~ stage4_choice = 1
    ~ relationship_with_manager = relationship_with_manager + 1
    ~ readiness_score = readiness_score + 1
    {tone:
    - 1: You wait. And wait. The meeting runs over by 45 minutes. When {manager_name} finally emerges, they appreciate that you flagged the issue — but the delay means you'll be working late to meet the deadline. Still, {manager_name} trusts you a little more for not panicking.
    - 2: You wait for {manager_name}'s meeting to conclude. The 45-minute delay compresses your timeline. However, when you raise the issue directly with {manager_name}, they clarify the data format and note your professionalism in waiting.
    - 3: ⏳ WAITED... 45 minutes. {manager_name} clarifies the issue but you're now behind schedule. Manager relationship +1 though!
    }
    {tone == 3: <i>[Manager +1 · Readiness +1 · Total: {readiness_score}]</i>}
    -> work_task_outcome

+ {confidence >= 40} [Knock on the door and ask {manager_name} directly]
    ~ stage4_choice = 2
    ~ relationship_with_manager = relationship_with_manager - 1
    ~ readiness_score = readiness_score + 2
    {tone:
    - 1: You knock. {manager_name} steps out, slightly flustered. You explain the issue quickly and get your answer in two minutes. The task gets done on time. But you catch a look from {manager_name} later — interrupting a meeting isn't ideal, even when you're stuck.
    - 2: You interrupt {manager_name}'s meeting. The issue is resolved quickly and the task is completed on time. However, {manager_name} later mentions that interrupting meetings should be a last resort. Your initiative is noted, but so is the breach of workplace etiquette.
    - 3: 🚪 KNOCKED! {manager_name} answers (slightly annoyed). Problem solved fast, task done on time! But Manager relationship -1. Worth it?
    }
    {tone == 3: <i>[Manager -1 · Readiness +2 · Total: {readiness_score}]</i>}
    -> work_task_outcome

+ [Ask Sam, the colleague across from you]
    ~ stage4_choice = 3
    ~ relationship_with_colleagues = relationship_with_colleagues + 2
    ~ asked_for_help = true
    ~ readiness_score = readiness_score + 2
    {tone:
    - 1: Sam looks up, smiles. "Oh yeah, that data format changed last month — here, let me show you." In five minutes, you're back on track. And you've just made your first workplace connection. That matters more than you might think right now.
    - 2: Sam is familiar with the data format change and explains it immediately. The issue is resolved without delay. You complete the task on time and have established a productive working relationship with a colleague.
    - 3: 🤝 SAM TO THE RESCUE! Problem solved in 5 minutes. Colleague relationship +2! And you unlocked the "Asks For Help" trait!
    }
    {tone == 3: <i>[Colleagues +2 · Readiness +2 · asked_for_help = true · Total: {readiness_score}]</i>}
    -> work_task_outcome


=== work_task_outcome ===

{tone:
- 1: By Thursday afternoon, the summary is done. It's not perfect — your first piece of real work never is — but it's yours, and you delivered it. {manager_name} scans it, nods, and says, "Good start." Those two words mean more than you expected.
- 2: You submit the completed summary by the Thursday deadline. {manager_name} reviews it and provides brief positive feedback. Your first deliverable is recorded.
- 3: 📊 TASK COMPLETE! {manager_name} says "Good start." First deliverable: DONE. Achievement unlocked: "Delivered Under Pressure"!
}

~ readiness_score = readiness_score + 1
{tone == 3: <i>[Readiness +1 · Total: {readiness_score}]</i>}

+ [What if I'd handled it differently?]
    -> shadow_after_stage4


=== shadow_after_stage4 ===

{tone:
- 1: A peek at how the other paths would have gone:
- 2: <b>Paths-not-taken — alternative outcomes:</b>
- 3: 🔮 ALT TIMELINE PEEK!
}

{stage4_choice == 1:
    // Player waited; show interrupt + colleague alternatives
    {tone:
    - 1: If you'd knocked on {manager_name}'s door, you'd have got the answer fast and finished on time — but {manager_name} would have noted the interruption, and your standing would have taken a small hit.
    - 2: Had you interrupted {manager_name}'s meeting, the issue would have been resolved quickly but your relationship with the manager would have suffered.
    - 3: 🔮 If you'd KNOCKED: fast fix, Manager -1, on-time delivery. Tradeoff city.
    }
    {tone:
    - 1: If you'd asked Sam, you'd have unlocked your first real workplace connection — and finished on time without the awkwardness. The lesson: colleagues are a resource, not a last resort.
    - 2: Had you asked Sam, the issue would have been resolved efficiently while building a peer relationship. This is generally the strongest workplace strategy.
    - 3: 🔮 If you'd ASKED SAM: best path. Colleagues +2, on-time, Asks-For-Help unlocked. The optimal play.
    }
}

{stage4_choice == 2:
    // Player interrupted; show wait + colleague alternatives
    {tone:
    - 1: If you'd waited for {manager_name}, you'd have run late — but you'd have built more trust with your manager and avoided the awkward look later.
    - 2: Had you waited, you would have missed your deadline by a small margin but maintained a stronger manager relationship.
    - 3: 🔮 If you'd WAITED: late delivery, Manager +1. Patience over pace.
    }
    {tone:
    - 1: If you'd asked Sam, you'd have got the answer in five minutes — no interruption, no awkward look from {manager_name}, and a new ally on the team.
    - 2: Had you asked Sam, the issue would have been resolved without disrupting management or compromising the deadline. This is the most efficient approach.
    - 3: 🔮 If you'd ASKED SAM: zero downsides. Fast fix + Colleagues +2. The optimal play.
    }
}

{stage4_choice == 3:
    // Player asked colleague; show wait + interrupt alternatives
    {tone:
    - 1: If you'd waited for {manager_name}, you'd have built manager trust — but worked late and missed the chance to bond with Sam.
    - 2: Had you waited for the manager, you would have built management trust at the cost of your timeline.
    - 3: 🔮 If you'd WAITED: late delivery, Manager +1. Slower but loyal.
    }
    {tone:
    - 1: If you'd knocked on {manager_name}'s door, you'd have got the answer quickly but at the cost of {manager_name}'s patience. Asking Sam was the smarter call.
    - 2: Had you interrupted {manager_name}, the issue would have been resolved fast but your manager relationship would have taken a hit.
    - 3: 🔮 If you'd KNOCKED: fast but Manager -1. You picked the better path.
    }
}

+ [Move on to Stage 5]
    -> the_lunchroom_moment


// ============================================================================
// STAGE 5: THE LUNCHROOM MOMENT
// ============================================================================

=== the_lunchroom_moment ===

# CLEAR
# bg: lunchroom
# char: jordan

{tone:
- 1: Stage 5. Not every important moment at work happens at your desk. Sometimes the real test is in the lunchroom.
- 2: <b>Stage 5: The Lunchroom Moment.</b> Workplace social dynamics often play out in informal settings. This stage tests your ability to navigate an unscripted social situation.
- 3: 🍰 <b>STAGE 5: THE LUNCHROOM MOMENT</b>. SOCIAL ENCOUNTER! This isn't about spreadsheets — it's about people.
}

It's Friday afternoon. {chosen_company == "NexusPoint Systems": You head into the breakout space — standing desks pushed back, kombucha taps to one side — } {chosen_company == "IronVale Resources": You duck into the smoko shed behind the main office, the kettle hissing on the bench — } {chosen_company == "Meridian Advisory": You walk into the polished kitchen on the consultant floor, espresso machine humming — } {chosen_company == "Metro Council WA": You head into the staff tea room, where the biscuit tin and the same mugs have probably been there since the eighties — } {chosen_company == "Southern Cross Financial": You step into the glass-walled meeting room they've repurposed for the occasion — } {chosen_company == "Horizon Foundation": You walk into the shared community space, the one with the mismatched mugs and the wonky kettle — }and find a dozen colleagues gathered around a cake. It's someone's birthday — a team leader named Jordan you haven't met yet.

{tone:
- 1: Someone starts singing Happy Birthday, and the whole group joins in. A few people glance at you standing near the doorway. You don't know the words to the second verse — does anyone? — but the group is warm and the energy is infectious.
- 2: The group begins singing Happy Birthday. You are standing at the periphery. Several colleagues make eye contact with you. Participation expectations in this social context are ambiguous.
- 3: 🎵 HAPPY BIRTHDAY TO YOU... The singing starts. Everyone's looking at the cake. A few people glance your way. SOCIAL AWARENESS CHECK:
}

+ [Join in — sing along and grab a slice of cake]
    ~ stage5_choice = 1
    ~ relationship_with_colleagues = relationship_with_colleagues + 2
    ~ reading_the_room = reading_the_room + 1
    ~ confidence = confidence + 5
    {tone:
    - 1: You jump in. Your singing is terrible — truly awful — but nobody cares. Jordan catches your eye and grins. "Thanks for joining in! I don't think we've met — you must be the new intern." Just like that, you're part of the group.
    - 2: You participate in the celebration. Jordan introduces themselves and welcomes you. Several colleagues engage you in brief conversation. You have successfully integrated into a social setting.
    - 3: 🎶 YOU SANG! (Badly, but enthusiastically.) Jordan introduces themselves. You're officially part of the crew! Colleagues +2, Confidence +5!
    }
    {tone == 3: <i>[Colleagues +2 · Social Awareness +1 · Confidence +5]</i>}
    -> lunchroom_outcome

+ [Smile and wave from the side — don't sing, but stay present]
    ~ stage5_choice = 2
    ~ relationship_with_colleagues = relationship_with_colleagues + 1
    ~ reading_the_room = reading_the_room + 2
    {tone:
    - 1: You hang back with a smile, clapping when the song ends. A colleague next to you leans over — "Smart move, I can't sing either." You share a laugh. Sometimes being present is enough.
    - 2: You observe from the periphery while maintaining engaged body language. A colleague acknowledges your presence. You demonstrate social awareness without overstepping as a new team member.
    - 3: 👋 STRATEGIC POSITIONING! You stayed, you smiled, you clapped. Social Awareness +2! Sometimes the best move is the subtle one.
    }
    {tone == 3: <i>[Colleagues +1 · Social Awareness +2]</i>}
    -> lunchroom_outcome

+ [Leave quietly — this feels too awkward]
    ~ stage5_choice = 3
    ~ reading_the_room = reading_the_room - 1
    ~ confidence = confidence - 5
    {tone:
    - 1: You slip out. In the corridor, you wonder if anyone noticed. They probably did. It's not a disaster — but you missed a chance to connect, and those chances don't come around as often as you'd think.
    - 2: You exit the lunchroom. While this avoids an uncomfortable situation, it represents a missed opportunity for informal networking. Social withdrawal in workplace settings can be perceived as disengagement.
    - 3: 🚶 RETREAT! You left the party. Nobody said anything but... you missed a connection opportunity. Confidence -5. Social Awareness -1.
    }
    {tone == 3: <i>[Social Awareness -1 · Confidence -5]</i>}
    -> lunchroom_outcome


=== lunchroom_outcome ===

~ readiness_score = readiness_score + 1

{tone:
- 1: Small moments like these add up. The people you connect with — or don't — shape what your internship feels like day to day. It's not just about the work.
- 2: Workplace social dynamics contribute significantly to internship outcomes. Relationship building in informal contexts affects collaboration, mentorship opportunities, and overall workplace satisfaction.
- 3: 🏢 Social encounters matter more than you think. Your workplace rep is building... or isn't.
}

{tone == 3: <i>[Readiness +1 · Total: {readiness_score}]</i>}

+ [What if I'd reacted differently?]
    -> shadow_after_stage5


=== shadow_after_stage5 ===

{tone:
- 1: A glimpse at the other ways that moment could have played out:
- 2: <b>Paths-not-taken — alternative outcomes:</b>
- 3: 🔮 ALT TIMELINE PEEK!
}

{stage5_choice == 1:
    // Player joined; show wave + leave
    {tone:
    - 1: If you'd hung back with a smile, you'd still have made a connection — quieter, more observational. Sometimes that's the right read of the room.
    - 2: Had you observed without participating, you would have demonstrated social awareness without the risk of overstepping.
    - 3: 🔮 If you'd WAVED: Social Awareness +2. Subtle but sound.
    }
    {tone:
    - 1: If you'd left, you'd have missed the moment entirely — and Jordan would have remembered the new face that didn't stay.
    - 2: Had you left, you would have avoided discomfort but lost an informal networking opportunity. Social withdrawal is often noticed.
    - 3: 🔮 If you'd LEFT: Confidence -5, Social Awareness -1. Missed XP.
    }
}

{stage5_choice == 2:
    // Player waved; show join + leave
    {tone:
    - 1: If you'd jumped in and sung, you'd have made a louder splash — Jordan would have introduced themselves directly, and you'd have walked out of there feeling lighter.
    - 2: Had you actively participated, you would have built stronger immediate connections at the cost of slightly less observational distance.
    - 3: 🔮 If you'd SUNG: Colleagues +2, Confidence +5. Bigger splash.
    }
    {tone:
    - 1: If you'd left, you'd have ducked the moment entirely — but you'd also have ducked the chance to be seen as part of the team.
    - 2: Had you left, you would have avoided the discomfort but missed a networking opportunity that costs little to participate in.
    - 3: 🔮 If you'd LEFT: missed connection, Social Awareness -1. Avoidance ≠ awareness.
    }
}

{stage5_choice == 3:
    // Player left; show join + wave
    {tone:
    - 1: If you'd joined in singing, you'd have laughed at your own bad voice and walked out with Jordan knowing your name. The team would have remembered the new intern who showed up.
    - 2: Had you participated, you would have built relationships and social standing in the team — typically a high-value, low-cost workplace move.
    - 3: 🔮 If you'd SUNG: Colleagues +2, Confidence +5. The big move.
    }
    {tone:
    - 1: Even if you'd just smiled and waved from the side, you'd have stayed present — and that quiet participation often counts more than people realise.
    - 2: Had you remained while observing, you would have demonstrated social awareness without overstepping. A safer, still-positive option.
    - 3: 🔮 If you'd WAVED: Social Awareness +2. The middle path was right there.
    }
}

+ [Move on to Stage 6]
    -> the_exit_interview


// ============================================================================
// STAGE 6: THE EXIT INTERVIEW
// ============================================================================

=== the_exit_interview ===

# CLEAR
# bg: managers_office
# char: manager

{tone:
- 1: Stage 6. The final chapter. Twelve weeks have flown by, and now you're sitting across from {manager_name} one last time. This isn't an assessment — it's a conversation. A chance to reflect on what happened and what you'll take with you.
- 2: <b>Stage 6: The Exit Interview.</b> Your 12-week internship at {chosen_company} has concluded. {manager_name}, your line manager, conducts the exit interview. This is a reflective and feedback-oriented conversation.
- 3: 🏁 <b>STAGE 6: THE EXIT INTERVIEW</b>. Final stage! Twelve weeks done. Time to reflect, receive feedback, and close the loop.
}

{manager_name} starts with an open question: "What do you think went well during your time here?"

+ [The work — I improved at the technical tasks]
    ~ readiness_score = readiness_score + 1
    {tone:
    - 1: You talk about how the work challenged you — how that first data task felt impossible, and how by week eight you were handling similar tasks without breaking a sweat. {manager_name} nods. "That's real growth."
    - 2: You identify specific technical skills developed during the placement. {manager_name} acknowledges your competency development and notes it in the exit documentation.
    - 3: 💪 TECHNICAL GROWTH highlighted! {manager_name} agrees — you've levelled up.
    }
    {tone == 3: <i>[Readiness +1]</i>}
    -> exit_feedback

+ [The people — I learned how to work in a team]
    ~ readiness_score = readiness_score + 2
    ~ relationship_with_colleagues = relationship_with_colleagues + 1
    {tone:
    - 1: You tell {manager_name} about Sam's help in that first week, about the birthday singing, about learning to read the room in meetings. {manager_name} smiles. "That's what most people miss. The work skills come with time — the people skills are what make you someone others want to work with."
    - 2: You emphasise interpersonal and collaborative skills developed through workplace relationships. {manager_name} notes that these "soft skills" are frequently cited as the most valuable internship outcome by employers.
    - 3: 🤝 PEOPLE SKILLS IDENTIFIED! {manager_name} says that's what separates good interns from great ones. Readiness +2!
    }
    {tone == 3: <i>[Readiness +2 · Colleagues +1]</i>}
    -> exit_feedback

+ [Honestly, I'm not sure — it was overwhelming]
    ~ readiness_score = readiness_score + 1
    ~ confidence = confidence + 5
    {tone:
    - 1: You're honest. "It was a lot." {manager_name} leans back. "That's actually one of the most self-aware things an intern has said to me. The fact that you recognise it was overwhelming means you were paying attention. That's not nothing."
    - 2: You express that the experience was challenging to process. {manager_name} reframes this as a positive indicator of engagement and self-awareness, noting that discomfort often signals meaningful learning.
    - 3: 🤔 HONESTY MODE! {manager_name} respects the vulnerability. "Self-awareness is a skill too." Confidence +5!
    }
    {tone == 3: <i>[Readiness +1 · Confidence +5]</i>}
    -> exit_feedback


=== exit_feedback ===

{tone:
- 1: Then {manager_name} shifts gears. "I want to give you some honest feedback too. Is that okay?"
- 2: {manager_name} transitions to constructive feedback. "I'd like to share some observations from the team."
- 3: 💬 FEEDBACK INCOMING! {manager_name} has some notes for you...
}

// Dynamic feedback — surfaces up to 2 issues from the player's weakest areas.
// Thresholds use < 0 (not <= 0) so a player who never had a negative
// interaction doesn't get penalised at the default zero state.
~ temp issues_shown = 0

{relationship_with_colleagues < 0:
    {manager_name} says: <i>"You kept to yourself quite a bit. The team noticed. I'd encourage you to be more proactive about building connections in your next role — it makes the work better for everyone."</i>
    ~ issues_shown = issues_shown + 1
}

{issues_shown < 2 && relationship_with_manager < 0:
    {issues_shown > 0:
        {manager_name} adds: <i>"And one more thing — there were times I wasn't sure where you were at with tasks. A quick check-in goes a long way."</i>
    - else:
        {manager_name} says: <i>"There were times I wasn't sure where you were at with tasks. Next time, try checking in more regularly with your manager — even a quick update goes a long way."</i>
    }
    ~ issues_shown = issues_shown + 1
}

{issues_shown < 2 && asked_for_help == false:
    {issues_shown > 0:
        {manager_name} adds: <i>"And — I noticed you tended to work through problems alone. Asking for help isn't a weakness."</i>
    - else:
        {manager_name} says: <i>"I noticed you tended to work through problems on your own, even when you were stuck. Asking for help isn't a weakness — it's a skill. Don't be afraid to use it."</i>
    }
    ~ issues_shown = issues_shown + 1
}

{issues_shown < 2 && reading_the_room < 0:
    {issues_shown > 0:
        {manager_name} adds: <i>"And — workplace culture takes time to read. Pay attention to the social dynamics; they matter more than you think."</i>
    - else:
        {manager_name} says: <i>"Workplace culture can be tricky to navigate. I'd encourage you to pay more attention to the social dynamics around you — joining in, reading the room. It matters more than you think."</i>
    }
    ~ issues_shown = issues_shown + 1
}

{issues_shown == 0:
    {manager_name} says: <i>"Honestly, you did well across the board. My only note is to keep challenging yourself — don't get comfortable. Push for the harder tasks next time."</i>
}

How do you respond?

+ [Accept it gracefully]
    ~ stage6_choice = 1
    ~ readiness_score = readiness_score + 3
    ~ relationship_with_manager = relationship_with_manager + 1
    {tone:
    - 1: You nod. "Thank you — I needed to hear that." {manager_name} looks genuinely pleased. Accepting feedback well is a skill most people never master. You just did.
    - 2: You acknowledge the feedback constructively. {manager_name} notes your professional response and records a positive final assessment.
    - 3: ✅ GRACEFUL ACCEPTANCE! {manager_name} is impressed. That's a rare skill. Manager +1, Readiness +3!
    }
    {tone == 3: <i>[Readiness +3 · Manager +1]</i>}
    -> shadow_after_stage6

+ [Get defensive — you disagree]
    ~ stage6_choice = 2
    ~ confidence = confidence - 5
    ~ relationship_with_manager = relationship_with_manager - 1
    {tone:
    - 1: "I don't think that's fair," you say. {manager_name}'s expression shifts — not angry, just... disappointed. The feedback might sting, but how you receive it says as much about you as what you did during the internship. This is a moment you'll replay later.
    - 2: You challenge {manager_name}'s assessment. The conversation becomes tense. {manager_name} maintains their position. Your defensive response is noted in the exit documentation.
    - 3: 🛡️ DEFENSIVE! {manager_name} frowns. The feedback stands, and now the vibe is awkward. Manager -1, Confidence -5. Not your best move.
    }
    ~ readiness_score = readiness_score + 0
    {tone == 3: <i>[Manager -1 · Confidence -5 · Readiness +0]</i>}
    -> shadow_after_stage6

+ [Ask for specifics — "Can you give me an example?"]
    ~ stage6_choice = 3
    ~ readiness_score = readiness_score + 2
    ~ relationship_with_manager = relationship_with_manager + 2
    {tone:
    - 1: {manager_name} pauses, then smiles. "Actually — yes." They give you a specific example, and suddenly the feedback clicks. Asking for details isn't defensive. It shows you want to learn, not just hear.
    - 2: You request specific examples. {manager_name} provides a concrete instance. This demonstrates active engagement with feedback and a growth-oriented mindset. {manager_name} notes this as a strong professional behaviour.
    - 3: 🔍 ASKED FOR SPECIFICS! {manager_name} gives a real example and the feedback finally clicks. This is the BEST response! Manager +2, Readiness +2!
    }
    {tone == 3: <i>[Readiness +2 · Manager +2]</i>}
    -> shadow_after_stage6


=== shadow_after_stage6 ===

{tone:
- 1: One last glimpse — how the other responses might have landed:
- 2: <b>Paths-not-taken — alternative outcomes:</b>
- 3: 🔮 FINAL ALT TIMELINE PEEK!
}

{stage6_choice == 1:
    // Player accepted gracefully; show defensive + specifics
    {tone:
    - 1: If you'd pushed back, {manager_name} would have held their ground — and you'd have walked out of that room with the conversation feeling like a loss instead of a gift.
    - 2: Had you been defensive, the relationship would have soured at the final moment, undermining an otherwise productive placement.
    - 3: 🔮 If you'd PUSHED BACK: Manager -1, Confidence -5. End on a sour note.
    }
    {tone:
    - 1: If you'd asked for a specific example, {manager_name} would have respected the curiosity even more — turning vague feedback into something you could actually use.
    - 2: Had you asked for specifics, you would have demonstrated the highest level of feedback engagement and gained actionable insight. This is the strongest response.
    - 3: 🔮 If you'd ASKED FOR SPECIFICS: Manager +2, Readiness +2. Even better than what you did.
    }
}

{stage6_choice == 2:
    // Player got defensive; show accept + specifics
    {tone:
    - 1: If you'd just nodded and accepted it, {manager_name} would have been pleased — and you'd have left the conversation with your dignity intact and a stronger reference letter.
    - 2: Had you accepted the feedback gracefully, you would have demonstrated professional maturity and strengthened your final impression.
    - 3: 🔮 If you'd ACCEPTED: Manager +1, Readiness +3. Big miss.
    }
    {tone:
    - 1: If you'd asked for a specific example, the feedback would have made sense — and {manager_name} would have walked away thinking you were the kind of intern they'd hire back.
    - 2: Had you requested specifics, the feedback would have become actionable rather than abstract, and the manager relationship would have ended on a high note.
    - 3: 🔮 If you'd ASKED FOR SPECIFICS: Manager +2, Readiness +2. The play of the day.
    }
}

{stage6_choice == 3:
    // Player asked for specifics; show accept + defensive
    {tone:
    - 1: If you'd just accepted it without probing, {manager_name} would still have been pleased — but you'd have walked away with vague advice instead of something concrete you could use.
    - 2: Had you accepted without probing, the feedback would have been less actionable but the response still professional.
    - 3: 🔮 If you'd just ACCEPTED: Manager +1, Readiness +3. Good but not great.
    }
    {tone:
    - 1: If you'd pushed back, the conversation would have soured. {manager_name} would have remembered the defensive intern, not the curious one. You picked the better path.
    - 2: Had you been defensive, the manager relationship would have ended poorly. Your actual choice was the strongest available response.
    - 3: 🔮 If you'd PUSHED BACK: Manager -1, Confidence -5. You dodged the worst path.
    }
}

+ [See your final results]
    -> end_summary


// ============================================================================
// END SUMMARY
// ============================================================================

=== end_summary ===

# CLEAR
# bg: title
# char: none

// Calculate tier
~ temp tier = 0
{readiness_score >= 14:
    ~ tier = 3
- else:
    {readiness_score >= 8:
        ~ tier = 2
    - else:
        ~ tier = 1
    }
}

{tone:
- 1: And just like that — your internship is done. Let's take a moment to look back at how it went.
- 2: <b>Internship Complete.</b> The following is a summary of your performance across all six stages.
- 3: 🏆 <b>GAME OVER — FINAL RESULTS!</b>
}

// === Score display (playful mode) ===
{tone == 3:
    <b>═══ FINAL SCORECARD ═══</b>
    Readiness Score: <b>{readiness_score}</b>
    Confidence: <b>{confidence}</b>
    Manager Relationship: <b>{relationship_with_manager}</b>
    Colleague Relationship: <b>{relationship_with_colleagues}</b>
    Social Awareness: <b>{reading_the_room}</b>
    Asked for Help: <b>{asked_for_help}</b>
    <b>═══════════════════════</b>
}

// === Tier feedback ===
{tier == 3:
    {tone:
    - 1: You navigated this internship with real awareness. You made thoughtful choices, built genuine connections, and handled feedback with maturity. Whatever comes next, you're ready for it. I mean that.
    - 2: <b>Rating: Excellent.</b> Your performance across all six stages demonstrates strong readiness for professional placement. You demonstrated initiative, social awareness, and reflective capacity.
    - 3: 🌟 <b>RATING: EXCELLENT!</b> You crushed it. Top-tier intern material. The workplace is ready for you.
    }
- else:
    {tier == 2:
        {tone:
        - 1: Solid work. You made some great choices and stumbled in a few places — and that's exactly how it should be. The fact that you can see where you'd do things differently next time? That's the whole point.
        - 2: <b>Rating: Competent.</b> Your performance indicates adequate readiness with identified areas for development. Further practice and reflection will strengthen your professional profile.
        - 3: ⭐ <b>RATING: SOLID!</b> Good run with room to grow. A few different choices could bump you to Excellent. Try again?
        }
    - else:
        {tone:
        - 1: This one was tough, wasn't it? And that's okay. The primer exists so you can stumble here — not in a real internship. You've seen the patterns now. You know what to look for. Next time through, try a different path. You'll be surprised how much changes.
        - 2: <b>Rating: Developing.</b> Your performance indicates that additional preparation would be beneficial before undertaking a professional placement. Consider replaying to explore alternative approaches.
        - 3: 📉 <b>RATING: NEEDS WORK.</b> But that's literally why this game exists! You've seen the patterns. Replay and level up!
        }
    }
}

// === Key moments recap ===

{tone:
- 1: Here's what stood out:
- 2: Key observations from your simulation:
- 3: 📋 HIGHLIGHT REEL:
}

{rushed_application:
    {tone:
    - 1: • You rushed your application. Speed isn't always your friend — a tailored resume makes a real difference.
    - 2: • Application was submitted without tailoring. Consider the impact of preparation time on application quality.
    - 3: • ⚡ You speed-ran the application. Next time, try the patient route.
    }
- else:
    {tone:
    - 1: • You took the time to prepare properly. That patience paid off.
    - 2: • You demonstrated strategic patience by waiting to submit a stronger application.
    - 3: • 🧘 You played the long game on the application. Smart.
    }
}

{got_interview == false:
    {tone:
    - 1: • Your resume didn't make the cut — but you learned from it. That reflection is worth more than you think.
    - 2: • Initial application was unsuccessful. The reflective learning from rejection was documented.
    - 3: • 📧 Got rejected but gained XP from reflection. Classic learning-from-failure arc.
    }
}

{chose_to_reschedule:
    {tone:
    - 1: • You rescheduled the interview. Knowing when you're not ready is a strength, not a weakness.
    - 2: • Interview rescheduling demonstrated self-awareness and preparation discipline.
    - 3: • 📅 Rescheduled the interview. Prep time = power move.
    }
}

{asked_for_help:
    {tone:
    - 1: • You asked a colleague for help. That's not weakness — that's how good teams work.
    - 2: • You sought assistance from a colleague, demonstrating collaborative problem-solving.
    - 3: • 🤝 Asked for help! Unlocked the collaboration trait.
    }
- else:
    {tone:
    - 1: • You didn't ask anyone for help during the work task. Next time, remember — reaching out isn't giving up.
    - 2: • No peer assistance was sought during the work task. Consider the benefits of collaborative problem-solving.
    - 3: • 🐺 Lone wolf on the work task. Try asking for help next time — it's a power-up, not a penalty.
    }
}

// === Closing ===

{tone:
- 1: Whatever path you took, you've now walked through the full intern journey once. When the real thing comes, you'll recognise the moments. And that recognition? That's readiness.
- 2: This primer has introduced the six stages you will encounter in a professional internship. Consider which decisions led to the strongest outcomes and how you might approach them differently.
- 3: 🎮 You've completed the WorkReady Primer! Your choices shaped your journey. Different paths lead to different outcomes — and there's always more to discover.
}

+ [Play again with a different approach]
    -> title_screen
+ [I'm done — thanks for the experience]
    {tone:
    - 1: Go get 'em. You're more ready than you think. 💛
    - 2: Thank you for completing the WorkReady Primer. Good luck with your placement.
    - 3: 🏆 THANKS FOR PLAYING! See you in the real world, intern!
    }
    -> END
