-- =====================================================
-- 🗄️ IAS Test Series Database Population Script
-- =====================================================
-- This script populates the Supabase database with all dummy data
-- from the Flutter app's mock services.
-- 
-- Tables populated:
-- - users
-- - subjects  
-- - chapters
-- - tests
-- - questions
-- - options
-- - exams
-- - exam_papers
-- - user_attempts
-- - user_responses
-- - progress
-- - analytics
-- - feedback
-- =====================================================

-- =====================================================
-- 1. USERS TABLE
-- =====================================================
INSERT INTO users (
    id, name, email, phone, avatar_url, date_of_birth, 
    target_year, preferred_subjects, study_goals, 
    overall_progress, created_at, updated_at
) VALUES (
    '1',
    'Deepak Yadav',
    'deepak@example.com',
    '+91-9876543210',
    'https://example.com/avatar.jpg',
    '1995-06-15',
    2025,
    ARRAY['polity', 'geography', 'economy'],
    'Crack UPSC CSE 2025 with comprehensive preparation',
    65.0,
    '2024-10-01T00:00:00Z',
    '2025-01-15T00:00:00Z'
);

-- =====================================================
-- 2. SUBJECTS TABLE
-- =====================================================
INSERT INTO subjects (
    id, name, description, icon, total_tests, 
    average_score, is_available, created_at, updated_at
) VALUES 
('polity', 'Polity', 'Indian Constitution, Governance, and Political System', '📘', 5, 72.0, true, '2024-10-01T00:00:00Z', '2025-01-15T00:00:00Z'),
('geography', 'Geography', 'Physical and Human Geography', '🌏', 0, 0.0, false, '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),
('economy', 'Economy', 'Indian Economy and Economic Concepts', '📊', 0, 0.0, false, '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z');

-- =====================================================
-- 3. CHAPTERS TABLE
-- =====================================================
INSERT INTO chapters (
    id, subject_id, title, description, chapter_order, 
    total_questions, is_completed, accuracy, created_at, updated_at
) VALUES 
-- Polity Chapters
('ch1', 'polity', 'Constitution of India', 'Historical background, making of the Constitution, salient features', 1, 25, false, NULL, '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),
('ch2', 'polity', 'Preamble', 'Philosophy of the Constitution, key words and concepts', 2, 25, false, NULL, '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),
('ch3', 'polity', 'Fundamental Rights', 'Articles 12-35, Right to Equality, Freedom, Constitutional Remedies', 3, 25, true, 75.0, '2024-10-01T00:00:00Z', '2025-01-15T00:00:00Z'),
('ch4', 'polity', 'Directive Principles', 'DPSPs, Fundamental Duties, relationship with FRs', 4, 25, true, 68.0, '2024-10-01T00:00:00Z', '2025-01-15T00:00:00Z'),
('ch5', 'polity', 'Parliamentary System', 'Lok Sabha, Rajya Sabha, Parliamentary procedures', 5, 25, false, NULL, '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),
('ch6', 'polity', 'Judiciary System', 'Supreme Court, High Courts, Judicial Review, PIL', 6, 25, false, NULL, '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),
('ch7', 'polity', 'Constitutional Amendments', 'Amendment procedure, important amendments', 7, 25, false, NULL, '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),
('ch8', 'polity', 'Federal System', 'Centre-State relations, 7th Schedule, Finance Commission', 8, 25, false, NULL, '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),
('ch9', 'polity', 'Local Government', 'Panchayati Raj, Municipalities, 73rd and 74th Amendments', 9, 25, false, NULL, '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),
('ch10', 'polity', 'Constitutional Bodies', 'Election Commission, UPSC, CAG, Finance Commission', 10, 25, false, NULL, '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),

-- Geography Chapters
('geo_1', 'geography', 'Physical Geography', 'Earth, Climate, Landforms', 1, 25, false, NULL, '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),
('geo_2', 'geography', 'Human Geography', 'Population, Settlements, Economic Activities', 2, 20, false, NULL, '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),
('geo_3', 'geography', 'Indian Geography', 'Physical Features, Climate, Resources', 3, 30, false, NULL, '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),

-- Economy Chapters
('econ_1', 'economy', 'Basic Concepts', 'GDP, Inflation, Monetary Policy', 1, 20, false, NULL, '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),
('econ_2', 'economy', 'Indian Economy', 'Planning, Budget, Banking', 2, 25, false, NULL, '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),
('econ_3', 'economy', 'International Trade', 'WTO, Balance of Payments, Forex', 3, 15, false, NULL, '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z');

-- =====================================================
-- 4. TESTS TABLE
-- =====================================================
INSERT INTO tests (
    id, subject_id, title, description, duration_minutes, 
    total_questions, test_type, status, can_retake, 
    created_at, updated_at
) VALUES 
-- Polity Chapter Tests
('test_ch1', 'polity', 'Constitution of India - Mini Test', 'Historical background, making of the Constitution, salient features', 30, 25, 'chapter', 'pending', true, '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),
('test_ch2', 'polity', 'Preamble - Mini Test', 'Philosophy of the Constitution, key words and concepts', 30, 25, 'chapter', 'pending', true, '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),
('test_ch3', 'polity', 'Fundamental Rights - Mini Test', 'Articles 12-35, Right to Equality, Freedom, Constitutional Remedies', 30, 25, 'chapter', 'completed', true, '2024-10-01T00:00:00Z', '2025-01-15T00:00:00Z'),
('test_ch4', 'polity', 'Directive Principles - Mini Test', 'DPSPs, Fundamental Duties, relationship with FRs', 30, 25, 'chapter', 'completed', true, '2024-10-01T00:00:00Z', '2025-01-15T00:00:00Z'),
('test_ch5', 'polity', 'Parliamentary System - Mini Test', 'Lok Sabha, Rajya Sabha, Parliamentary procedures', 30, 25, 'chapter', 'pending', true, '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),
('test_ch6', 'polity', 'Judiciary System - Mini Test', 'Supreme Court, High Courts, Judicial Review, PIL', 30, 25, 'chapter', 'pending', true, '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),
('test_ch7', 'polity', 'Constitutional Amendments - Mini Test', 'Amendment procedure, important amendments', 30, 25, 'chapter', 'pending', true, '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),
('test_ch8', 'polity', 'Federal System - Mini Test', 'Centre-State relations, 7th Schedule, Finance Commission', 30, 25, 'chapter', 'pending', true, '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),
('test_ch9', 'polity', 'Local Government - Mini Test', 'Panchayati Raj, Municipalities, 73rd and 74th Amendments', 30, 25, 'chapter', 'pending', true, '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),
('test_ch10', 'polity', 'Constitutional Bodies - Mini Test', 'Election Commission, UPSC, CAG, Finance Commission', 30, 25, 'chapter', 'pending', true, '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),

-- Polity Full Length Test
('polity_full_test', 'polity', 'Polity Full-Length Mock Test', 'Complete Polity test covering all chapters (100 questions)', 120, 100, 'full_length', 'pending', true, '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),

-- Mock Data Service Tests
('test1', 'polity', 'Indian Constitution', 'Fundamental concepts of Indian Constitution', 60, 20, 'practice', 'completed', true, '2024-10-01T00:00:00Z', '2025-01-15T00:00:00Z'),
('test2', 'polity', 'Fundamental Rights', 'Articles 12-35 of Indian Constitution', 60, 25, 'practice', 'retry', true, '2024-10-01T00:00:00Z', '2025-01-10T00:00:00Z'),
('test3', 'polity', 'Parliament System', 'Lok Sabha, Rajya Sabha and Parliamentary procedures', 60, 20, 'practice', 'pending', false, '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),
('test4', 'polity', 'Constitutional Amendments', 'Important amendments and their significance', 60, 22, 'practice', 'pending', false, '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),
('test5', 'polity', 'Judiciary System', 'Supreme Court, High Courts and Judicial Review', 60, 18, 'practice', 'pending', false, '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),

-- Geography Tests
('geo_test_1', 'geography', 'Physical Geography Test', 'Test your knowledge of physical geography', 30, 25, 'practice', 'pending', false, '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),
('geo_test_2', 'geography', 'Human Geography Test', 'Test your knowledge of human geography', 25, 20, 'practice', 'pending', false, '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),

-- Economy Tests
('econ_test_1', 'economy', 'Basic Concepts Test', 'Test your knowledge of basic economic concepts', 25, 20, 'practice', 'pending', false, '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),
('econ_test_2', 'economy', 'Indian Economy Test', 'Test your knowledge of Indian economy', 30, 25, 'practice', 'pending', false, '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z');

-- =====================================================
-- 5. QUESTIONS TABLE
-- =====================================================
INSERT INTO questions (
    id, test_id, question_text, question_type, topic, 
    difficulty_level, marks, explanation, created_at, updated_at
) VALUES 
-- Test 3 (Parliament System) Questions
('q1', 'test3', 'Who is the guardian of the Constitution of India?', 'mcq', 'Judiciary', 'medium', 2, 'The Supreme Court is the guardian of the Constitution of India.', '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),
('q2', 'test3', 'What is the maximum strength of Lok Sabha?', 'mcq', 'Parliament', 'easy', 2, 'The maximum strength of Lok Sabha is 550 (530 from states + 20 from Union Territories).', '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),
('q3', 'test3', 'Who presides over the joint sitting of Parliament?', 'mcq', 'Parliament', 'medium', 2, 'The Speaker of Lok Sabha presides over the joint sitting of Parliament.', '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),
('q4', 'test3', 'What is the tenure of Rajya Sabha?', 'mcq', 'Parliament', 'easy', 2, 'Rajya Sabha is a permanent house, with one-third of its members retiring every two years.', '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),
('q5', 'test3', 'Which article deals with the composition of Parliament?', 'mcq', 'Constitution', 'hard', 2, 'Article 79 deals with the composition of Parliament.', '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),

-- Chapter 1 Questions
('q1_ch1', 'test_ch1', 'Who was the Chairman of the Drafting Committee of the Constituent Assembly?', 'mcq', 'Constitution Making', 'easy', 2, 'Dr. B.R. Ambedkar was the Chairman of the Drafting Committee.', '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),
('q2_ch1', 'test_ch1', 'The Constitution of India was adopted on:', 'mcq', 'Constitution Making', 'easy', 2, 'The Constitution was adopted on 26th November 1949.', '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),

-- Chapter 2 Questions
('q1_ch2', 'test_ch2', 'Which of the following words was added to the Preamble by the 42nd Amendment?', 'mcq', 'Preamble', 'medium', 2, 'Both Socialist and Secular were added by the 42nd Amendment.', '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),

-- Chapter 3 Questions
('q1_ch3', 'test_ch3', 'Article 14 of the Constitution deals with:', 'mcq', 'Fundamental Rights', 'easy', 2, 'Article 14 deals with Right to Equality.', '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),

-- Chapter 4 Questions
('q1_ch4', 'test_ch4', 'Directive Principles of State Policy are:', 'mcq', 'Directive Principles', 'easy', 2, 'DPSPs are non-justiciable in nature.', '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),

-- Chapter 5 Questions
('q1_ch5', 'test_ch5', 'The maximum strength of Lok Sabha is:', 'mcq', 'Parliament', 'easy', 2, 'The maximum strength of Lok Sabha is 550.', '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),

-- Chapter 6 Questions
('q1_ch6', 'test_ch6', 'Who is the guardian of the Constitution of India?', 'mcq', 'Judiciary', 'easy', 2, 'The Supreme Court is the guardian of the Constitution.', '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),

-- Chapter 7 Questions
('q1_ch7', 'test_ch7', 'Which amendment is known as the "Mini Constitution"?', 'mcq', 'Constitutional Amendments', 'medium', 2, 'The 42nd Amendment is known as the Mini Constitution.', '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),

-- Chapter 8 Questions
('q1_ch8', 'test_ch8', 'The 7th Schedule of the Constitution deals with:', 'mcq', 'Federal System', 'medium', 2, 'The 7th Schedule deals with Union, State and Concurrent Lists.', '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),

-- Chapter 9 Questions
('q1_ch9', 'test_ch9', 'The 73rd Constitutional Amendment deals with:', 'mcq', 'Local Government', 'easy', 2, 'The 73rd Amendment deals with Panchayati Raj.', '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),

-- Chapter 10 Questions
('q1_ch10', 'test_ch10', 'The Comptroller and Auditor General of India is appointed by:', 'mcq', 'Constitutional Bodies', 'easy', 2, 'The CAG is appointed by the President.', '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),

-- Full Length Test Questions
('q1_full', 'polity_full_test', 'Who was the Chairman of the Drafting Committee of the Constituent Assembly?', 'mcq', 'Constitution Making', 'easy', 2, 'Dr. B.R. Ambedkar was the Chairman of the Drafting Committee.', '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z');

-- =====================================================
-- 6. OPTIONS TABLE
-- =====================================================
INSERT INTO options (
    id, question_id, option_text, option_order, is_correct, created_at
) VALUES 
-- Test 3 Questions Options
('opt_q1_1', 'q1', 'Parliament', 1, false, '2024-10-01T00:00:00Z'),
('opt_q1_2', 'q1', 'Supreme Court', 2, true, '2024-10-01T00:00:00Z'),
('opt_q1_3', 'q1', 'President', 3, false, '2024-10-01T00:00:00Z'),
('opt_q1_4', 'q1', 'Prime Minister', 4, false, '2024-10-01T00:00:00Z'),

('opt_q2_1', 'q2', '540', 1, false, '2024-10-01T00:00:00Z'),
('opt_q2_2', 'q2', '545', 2, false, '2024-10-01T00:00:00Z'),
('opt_q2_3', 'q2', '550', 3, true, '2024-10-01T00:00:00Z'),
('opt_q2_4', 'q2', '552', 4, false, '2024-10-01T00:00:00Z'),

('opt_q3_1', 'q3', 'President', 1, false, '2024-10-01T00:00:00Z'),
('opt_q3_2', 'q3', 'Vice President', 2, false, '2024-10-01T00:00:00Z'),
('opt_q3_3', 'q3', 'Speaker of Lok Sabha', 3, true, '2024-10-01T00:00:00Z'),
('opt_q3_4', 'q3', 'Prime Minister', 4, false, '2024-10-01T00:00:00Z'),

('opt_q4_1', 'q4', '5 years', 1, false, '2024-10-01T00:00:00Z'),
('opt_q4_2', 'q4', '6 years', 2, false, '2024-10-01T00:00:00Z'),
('opt_q4_3', 'q4', 'Permanent', 3, true, '2024-10-01T00:00:00Z'),
('opt_q4_4', 'q4', '3 years', 4, false, '2024-10-01T00:00:00Z'),

('opt_q5_1', 'q5', 'Article 79', 1, true, '2024-10-01T00:00:00Z'),
('opt_q5_2', 'q5', 'Article 80', 2, false, '2024-10-01T00:00:00Z'),
('opt_q5_3', 'q5', 'Article 81', 3, false, '2024-10-01T00:00:00Z'),
('opt_q5_4', 'q5', 'Article 82', 4, false, '2024-10-01T00:00:00Z'),

-- Chapter 1 Questions Options
('opt_q1_ch1_1', 'q1_ch1', 'Dr. B.R. Ambedkar', 1, true, '2024-10-01T00:00:00Z'),
('opt_q1_ch1_2', 'q1_ch1', 'Jawaharlal Nehru', 2, false, '2024-10-01T00:00:00Z'),
('opt_q1_ch1_3', 'q1_ch1', 'Dr. Rajendra Prasad', 3, false, '2024-10-01T00:00:00Z'),
('opt_q1_ch1_4', 'q1_ch1', 'Sardar Vallabhbhai Patel', 4, false, '2024-10-01T00:00:00Z'),

('opt_q2_ch1_1', 'q2_ch1', '26th January 1950', 1, false, '2024-10-01T00:00:00Z'),
('opt_q2_ch1_2', 'q2_ch1', '26th November 1949', 2, true, '2024-10-01T00:00:00Z'),
('opt_q2_ch1_3', 'q2_ch1', '15th August 1947', 3, false, '2024-10-01T00:00:00Z'),
('opt_q2_ch1_4', 'q2_ch1', '2nd October 1949', 4, false, '2024-10-01T00:00:00Z'),

-- Chapter 2 Questions Options
('opt_q1_ch2_1', 'q1_ch2', 'Socialist', 1, false, '2024-10-01T00:00:00Z'),
('opt_q1_ch2_2', 'q1_ch2', 'Secular', 2, false, '2024-10-01T00:00:00Z'),
('opt_q1_ch2_3', 'q1_ch2', 'Both Socialist and Secular', 3, true, '2024-10-01T00:00:00Z'),
('opt_q1_ch2_4', 'q1_ch2', 'None of the above', 4, false, '2024-10-01T00:00:00Z'),

-- Chapter 3 Questions Options
('opt_q1_ch3_1', 'q1_ch3', 'Right to Equality', 1, true, '2024-10-01T00:00:00Z'),
('opt_q1_ch3_2', 'q1_ch3', 'Right to Freedom', 2, false, '2024-10-01T00:00:00Z'),
('opt_q1_ch3_3', 'q1_ch3', 'Right against Exploitation', 3, false, '2024-10-01T00:00:00Z'),
('opt_q1_ch3_4', 'q1_ch3', 'Right to Constitutional Remedies', 4, false, '2024-10-01T00:00:00Z'),

-- Chapter 4 Questions Options
('opt_q1_ch4_1', 'q1_ch4', 'Justiciable', 1, false, '2024-10-01T00:00:00Z'),
('opt_q1_ch4_2', 'q1_ch4', 'Non-justiciable', 2, true, '2024-10-01T00:00:00Z'),
('opt_q1_ch4_3', 'q1_ch4', 'Partially justiciable', 3, false, '2024-10-01T00:00:00Z'),
('opt_q1_ch4_4', 'q1_ch4', 'None of the above', 4, false, '2024-10-01T00:00:00Z'),

-- Chapter 5 Questions Options
('opt_q1_ch5_1', 'q1_ch5', '540', 1, false, '2024-10-01T00:00:00Z'),
('opt_q1_ch5_2', 'q1_ch5', '545', 2, false, '2024-10-01T00:00:00Z'),
('opt_q1_ch5_3', 'q1_ch5', '550', 3, true, '2024-10-01T00:00:00Z'),
('opt_q1_ch5_4', 'q1_ch5', '552', 4, false, '2024-10-01T00:00:00Z'),

-- Chapter 6 Questions Options
('opt_q1_ch6_1', 'q1_ch6', 'Parliament', 1, false, '2024-10-01T00:00:00Z'),
('opt_q1_ch6_2', 'q1_ch6', 'Supreme Court', 2, true, '2024-10-01T00:00:00Z'),
('opt_q1_ch6_3', 'q1_ch6', 'President', 3, false, '2024-10-01T00:00:00Z'),
('opt_q1_ch6_4', 'q1_ch6', 'Prime Minister', 4, false, '2024-10-01T00:00:00Z'),

-- Chapter 7 Questions Options
('opt_q1_ch7_1', 'q1_ch7', '42nd Amendment', 1, true, '2024-10-01T00:00:00Z'),
('opt_q1_ch7_2', 'q1_ch7', '44th Amendment', 2, false, '2024-10-01T00:00:00Z'),
('opt_q1_ch7_3', 'q1_ch7', '73rd Amendment', 3, false, '2024-10-01T00:00:00Z'),
('opt_q1_ch7_4', 'q1_ch7', '74th Amendment', 4, false, '2024-10-01T00:00:00Z'),

-- Chapter 8 Questions Options
('opt_q1_ch8_1', 'q1_ch8', 'Fundamental Rights', 1, false, '2024-10-01T00:00:00Z'),
('opt_q1_ch8_2', 'q1_ch8', 'Union, State and Concurrent Lists', 2, true, '2024-10-01T00:00:00Z'),
('opt_q1_ch8_3', 'q1_ch8', 'Directive Principles', 3, false, '2024-10-01T00:00:00Z'),
('opt_q1_ch8_4', 'q1_ch8', 'Emergency Provisions', 4, false, '2024-10-01T00:00:00Z'),

-- Chapter 9 Questions Options
('opt_q1_ch9_1', 'q1_ch9', 'Municipalities', 1, false, '2024-10-01T00:00:00Z'),
('opt_q1_ch9_2', 'q1_ch9', 'Panchayati Raj', 2, true, '2024-10-01T00:00:00Z'),
('opt_q1_ch9_3', 'q1_ch9', 'Cooperative Societies', 3, false, '2024-10-01T00:00:00Z'),
('opt_q1_ch9_4', 'q1_ch9', 'Tribal Areas', 4, false, '2024-10-01T00:00:00Z'),

-- Chapter 10 Questions Options
('opt_q1_ch10_1', 'q1_ch10', 'President', 1, true, '2024-10-01T00:00:00Z'),
('opt_q1_ch10_2', 'q1_ch10', 'Prime Minister', 2, false, '2024-10-01T00:00:00Z'),
('opt_q1_ch10_3', 'q1_ch10', 'Parliament', 3, false, '2024-10-01T00:00:00Z'),
('opt_q1_ch10_4', 'q1_ch10', 'Supreme Court', 4, false, '2024-10-01T00:00:00Z'),

-- Full Length Test Questions Options
('opt_q1_full_1', 'q1_full', 'Dr. B.R. Ambedkar', 1, true, '2024-10-01T00:00:00Z'),
('opt_q1_full_2', 'q1_full', 'Jawaharlal Nehru', 2, false, '2024-10-01T00:00:00Z'),
('opt_q1_full_3', 'q1_full', 'Dr. Rajendra Prasad', 3, false, '2024-10-01T00:00:00Z'),
('opt_q1_full_4', 'q1_full', 'Sardar Vallabhbhai Patel', 4, false, '2024-10-01T00:00:00Z');

-- =====================================================
-- 7. EXAMS TABLE
-- =====================================================
INSERT INTO exams (
    id, title, description, release_date, end_date, 
    prelims_questions, prelims_duration, mains_questions, mains_duration,
    prelims_marks, mains_marks, status, created_at, updated_at
) VALUES 
('exam_1', 'Exam 1 - Q1 2025', 'January - March 2025', '2025-01-01T00:00:00Z', '2025-03-31T23:59:59Z', 100, 120, 4, 180, 200, 250, 'available', '2024-10-01T00:00:00Z', '2025-01-01T00:00:00Z'),
('exam_2', 'Exam 2 - Q2 2025', 'April - June 2025', '2025-04-01T00:00:00Z', '2025-06-30T23:59:59Z', 100, 120, 4, 180, 200, 250, 'locked', '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),
('exam_3', 'Exam 3 - Q3 2025', 'July - September 2025', '2025-07-01T00:00:00Z', '2025-09-30T23:59:59Z', 100, 120, 4, 180, 200, 250, 'locked', '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),
('exam_4', 'Exam 4 - Q4 2025', 'October - December 2025', '2025-10-01T00:00:00Z', '2025-12-31T23:59:59Z', 100, 120, 4, 180, 200, 250, 'locked', '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z');

-- =====================================================
-- 8. EXAM_PAPERS TABLE
-- =====================================================
INSERT INTO exam_papers (
    id, exam_id, paper_type, title, description, 
    duration_minutes, total_questions, total_marks, 
    subjects, is_completed, user_score, completed_at, created_at, updated_at
) VALUES 
-- Exam 1 Papers
('exam_1_paper_1', 'exam_1', 'prelims', 'General Studies Paper I', 'Current Affairs, History, Geography, Polity, Economy, Environment, Science', 120, 100, 200, ARRAY['Current Affairs', 'History', 'Geography', 'Polity', 'Economy', 'Environment', 'Science'], true, 75.0, '2025-01-15T00:00:00Z', '2024-10-01T00:00:00Z', '2025-01-15T00:00:00Z'),
('exam_1_paper_2', 'exam_1', 'prelims', 'CSAT Paper II', 'Comprehension, Reasoning, Maths, Decision Making', 120, 80, 200, ARRAY['Comprehension', 'Reasoning', 'Mathematics', 'Decision Making'], false, NULL, NULL, '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),
('exam_1_mains_1', 'exam_1', 'mains', 'GS Paper I', 'Indian Heritage & Culture, History, Geography', 180, 4, 250, ARRAY['Indian Heritage & Culture', 'History', 'Geography'], false, NULL, NULL, '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),
('exam_1_mains_2', 'exam_1', 'mains', 'GS Paper II', 'Polity, Governance, International Relations', 180, 4, 250, ARRAY['Polity', 'Governance', 'International Relations'], false, NULL, NULL, '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),

-- Exam 2 Papers
('exam_2_paper_1', 'exam_2', 'prelims', 'General Studies Paper I', 'Current Affairs, History, Geography, Polity, Economy, Environment, Science', 120, 100, 200, ARRAY['Current Affairs', 'History', 'Geography', 'Polity', 'Economy', 'Environment', 'Science'], false, NULL, NULL, '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),
('exam_2_paper_2', 'exam_2', 'prelims', 'CSAT Paper II', 'Comprehension, Reasoning, Maths, Decision Making', 120, 80, 200, ARRAY['Comprehension', 'Reasoning', 'Mathematics', 'Decision Making'], false, NULL, NULL, '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),
('exam_2_mains_1', 'exam_2', 'mains', 'GS Paper III', 'Economy, Science, Technology, Environment, Disaster Management', 180, 4, 250, ARRAY['Economy', 'Science', 'Technology', 'Environment', 'Disaster Management'], false, NULL, NULL, '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),
('exam_2_mains_2', 'exam_2', 'mains', 'GS Paper IV', 'Ethics, Integrity, Aptitude', 180, 4, 250, ARRAY['Ethics', 'Integrity', 'Aptitude'], false, NULL, NULL, '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),

-- Exam 3 Papers
('exam_3_paper_1', 'exam_3', 'prelims', 'General Studies Paper I', 'Current Affairs, History, Geography, Polity, Economy, Environment, Science', 120, 100, 200, ARRAY['Current Affairs', 'History', 'Geography', 'Polity', 'Economy', 'Environment', 'Science'], false, NULL, NULL, '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),
('exam_3_paper_2', 'exam_3', 'prelims', 'CSAT Paper II', 'Comprehension, Reasoning, Maths, Decision Making', 120, 80, 200, ARRAY['Comprehension', 'Reasoning', 'Mathematics', 'Decision Making'], false, NULL, NULL, '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),
('exam_3_mains_1', 'exam_3', 'mains', 'Essay Paper', 'Essay writing on various topics', 180, 2, 250, ARRAY['Essay Writing'], false, NULL, NULL, '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),
('exam_3_mains_2', 'exam_3', 'mains', 'Optional Paper I', 'Optional subject paper', 180, 4, 250, ARRAY['Optional Subject'], false, NULL, NULL, '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),

-- Exam 4 Papers
('exam_4_paper_1', 'exam_4', 'prelims', 'General Studies Paper I', 'Current Affairs, History, Geography, Polity, Economy, Environment, Science', 120, 100, 200, ARRAY['Current Affairs', 'History', 'Geography', 'Polity', 'Economy', 'Environment', 'Science'], false, NULL, NULL, '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),
('exam_4_paper_2', 'exam_4', 'prelims', 'CSAT Paper II', 'Comprehension, Reasoning, Maths, Decision Making', 120, 80, 200, ARRAY['Comprehension', 'Reasoning', 'Mathematics', 'Decision Making'], false, NULL, NULL, '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),
('exam_4_mains_1', 'exam_4', 'mains', 'Optional Paper II', 'Optional subject paper', 180, 4, 250, ARRAY['Optional Subject'], false, NULL, NULL, '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),
('exam_4_mains_2', 'exam_4', 'mains', 'Language Papers', 'Indian Language and English', 180, 4, 300, ARRAY['Indian Language', 'English'], false, NULL, NULL, '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z');

-- =====================================================
-- 9. USER_ATTEMPTS TABLE
-- =====================================================
INSERT INTO user_attempts (
    id, user_id, test_id, started_at, completed_at, 
    score, total_marks, percentage, status, time_taken_minutes, created_at, updated_at
) VALUES 
('attempt_1', '1', 'test1', '2025-01-15T10:00:00Z', '2025-01-15T11:00:00Z', 15.0, 20.0, 75.0, 'completed', 60, '2025-01-15T10:00:00Z', '2025-01-15T11:00:00Z'),
('attempt_2', '1', 'test2', '2025-01-10T14:00:00Z', '2025-01-10T15:00:00Z', 16.25, 25.0, 65.0, 'completed', 60, '2025-01-10T14:00:00Z', '2025-01-10T15:00:00Z'),
('attempt_3', '1', 'test_ch3', '2025-01-15T09:00:00Z', '2025-01-15T09:30:00Z', 18.75, 25.0, 75.0, 'completed', 30, '2025-01-15T09:00:00Z', '2025-01-15T09:30:00Z'),
('attempt_4', '1', 'test_ch4', '2025-01-15T10:00:00Z', '2025-01-15T10:30:00Z', 17.0, 25.0, 68.0, 'completed', 30, '2025-01-15T10:00:00Z', '2025-01-15T10:30:00Z'),
('attempt_5', '1', 'exam_1_paper_1', '2025-01-15T08:00:00Z', '2025-01-15T10:00:00Z', 150.0, 200.0, 75.0, 'completed', 120, '2025-01-15T08:00:00Z', '2025-01-15T10:00:00Z');

-- =====================================================
-- 10. USER_RESPONSES TABLE
-- =====================================================
INSERT INTO user_responses (
    id, attempt_id, question_id, selected_option_id, 
    is_correct, time_taken_seconds, created_at
) VALUES 
-- Test 1 Responses (Indian Constitution)
('resp_1', 'attempt_1', 'q1', 'opt_q1_2', true, 45, '2025-01-15T10:15:00Z'),
('resp_2', 'attempt_1', 'q2', 'opt_q2_3', true, 30, '2025-01-15T10:20:00Z'),
('resp_3', 'attempt_1', 'q3', 'opt_q3_3', true, 35, '2025-01-15T10:25:00Z'),
('resp_4', 'attempt_1', 'q4', 'opt_q4_3', true, 25, '2025-01-15T10:30:00Z'),
('resp_5', 'attempt_1', 'q5', 'opt_q5_1', true, 40, '2025-01-15T10:35:00Z'),

-- Test 2 Responses (Fundamental Rights)
('resp_6', 'attempt_2', 'q1', 'opt_q1_2', true, 50, '2025-01-10T14:15:00Z'),
('resp_7', 'attempt_2', 'q2', 'opt_q2_2', false, 35, '2025-01-10T14:20:00Z'),
('resp_8', 'attempt_2', 'q3', 'opt_q3_3', true, 40, '2025-01-10T14:25:00Z'),
('resp_9', 'attempt_2', 'q4', 'opt_q4_3', true, 30, '2025-01-10T14:30:00Z'),
('resp_10', 'attempt_2', 'q5', 'opt_q5_1', true, 45, '2025-01-10T14:35:00Z'),

-- Chapter 3 Responses (Fundamental Rights)
('resp_11', 'attempt_3', 'q1_ch3', 'opt_q1_ch3_1', true, 30, '2025-01-15T09:05:00Z'),
('resp_12', 'attempt_3', 'q1_ch3', 'opt_q1_ch3_2', false, 25, '2025-01-15T09:10:00Z'),
('resp_13', 'attempt_3', 'q1_ch3', 'opt_q1_ch3_3', false, 20, '2025-01-15T09:15:00Z'),
('resp_14', 'attempt_3', 'q1_ch3', 'opt_q1_ch3_4', false, 35, '2025-01-15T09:20:00Z'),
('resp_15', 'attempt_3', 'q1_ch3', 'opt_q1_ch3_1', true, 30, '2025-01-15T09:25:00Z'),

-- Chapter 4 Responses (Directive Principles)
('resp_16', 'attempt_4', 'q1_ch4', 'opt_q1_ch4_1', false, 25, '2025-01-15T10:05:00Z'),
('resp_17', 'attempt_4', 'q1_ch4', 'opt_q1_ch4_2', true, 30, '2025-01-15T10:10:00Z'),
('resp_18', 'attempt_4', 'q1_ch4', 'opt_q1_ch4_3', false, 20, '2025-01-15T10:15:00Z'),
('resp_19', 'attempt_4', 'q1_ch4', 'opt_q1_ch4_4', false, 35, '2025-01-15T10:20:00Z'),
('resp_20', 'attempt_4', 'q1_ch4', 'opt_q1_ch4_2', true, 30, '2025-01-15T10:25:00Z');

-- =====================================================
-- 11. PROGRESS TABLE
-- =====================================================
CREATE TABLE user_progress (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    subject_id VARCHAR(50) REFERENCES subjects(id) ON DELETE CASCADE,
    chapter_id VARCHAR(50) REFERENCES chapters(id) ON DELETE CASCADE,
    progress_percentage DECIMAL(5,2) DEFAULT 0,
    chapters_completed INTEGER DEFAULT 0,
    tests_completed INTEGER DEFAULT 0,
    total_time_spent_minutes INTEGER DEFAULT 0,
    average_score DECIMAL(5,2) DEFAULT 0,
    last_activity TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    UNIQUE(user_id, subject_id, chapter_id)
);

INSERT INTO user_progress (
    user_id, subject_id, chapter_id, 
    progress_percentage, completed_at, created_at, updated_at
) VALUES 
-- Subject Progress
('progress_1', '1', 'polity', NULL, NULL, 20.0, NULL, '2024-10-01T00:00:00Z', '2025-01-15T00:00:00Z'),
('progress_2', '1', 'geography', NULL, NULL, 0.0, NULL, '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),
('progress_3', '1', 'economy', NULL, NULL, 0.0, NULL, '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),

-- Chapter Progress
('progress_4', '1', 'polity', 'ch3', NULL, 100.0, '2025-01-15T09:30:00Z', '2025-01-15T09:30:00Z', '2025-01-15T09:30:00Z'),
('progress_5', '1', 'polity', 'ch4', NULL, 100.0, '2025-01-15T10:30:00Z', '2025-01-15T10:30:00Z', '2025-01-15T10:30:00Z'),

-- Test Progress
('progress_6', '1', 'polity', NULL, 'test1', 100.0, '2025-01-15T11:00:00Z', '2025-01-15T11:00:00Z', '2025-01-15T11:00:00Z'),
('progress_7', '1', 'polity', NULL, 'test2', 100.0, '2025-01-10T15:00:00Z', '2025-01-10T15:00:00Z', '2025-01-10T15:00:00Z'),
('progress_8', '1', 'polity', NULL, 'test_ch3', 100.0, '2025-01-15T09:30:00Z', '2025-01-15T09:30:00Z', '2025-01-15T09:30:00Z'),
('progress_9', '1', 'polity', NULL, 'test_ch4', 100.0, '2025-01-15T10:30:00Z', '2025-01-15T10:30:00Z', '2025-01-15T10:30:00Z');

-- =====================================================
-- 12. ANALYTICS TABLE
-- =====================================================
INSERT INTO analytics (
    id, user_id, metric_name, metric_value, metric_type, 
    subject_id, test_id, date_recorded, created_at
) VALUES 
('analytics_1', '1', 'overall_progress', 65.0, 'percentage', NULL, NULL, '2025-01-15', '2025-01-15T00:00:00Z'),
('analytics_2', '1', 'average_accuracy', 71.0, 'percentage', NULL, NULL, '2025-01-15', '2025-01-15T00:00:00Z'),
('analytics_3', '1', 'time_per_question', 1.8, 'minutes', NULL, NULL, '2025-01-15', '2025-01-15T00:00:00Z'),
('analytics_4', '1', 'polity_progress', 20.0, 'percentage', 'polity', NULL, '2025-01-15', '2025-01-15T00:00:00Z'),
('analytics_5', '1', 'polity_accuracy', 72.0, 'percentage', 'polity', NULL, '2025-01-15', '2025-01-15T00:00:00Z'),
('analytics_6', '1', 'test1_score', 75.0, 'percentage', 'polity', 'test1', '2025-01-15', '2025-01-15T11:00:00Z'),
('analytics_7', '1', 'test2_score', 65.0, 'percentage', 'polity', 'test2', '2025-01-10', '2025-01-10T15:00:00Z'),
('analytics_8', '1', 'chapters_completed', 2, 'count', 'polity', NULL, '2025-01-15', '2025-01-15T00:00:00Z'),
('analytics_9', '1', 'tests_completed', 4, 'count', 'polity', NULL, '2025-01-15', '2025-01-15T00:00:00Z'),
('analytics_10', '1', 'total_study_time', 180, 'minutes', NULL, NULL, '2025-01-15', '2025-01-15T00:00:00Z');

-- =====================================================
-- 13. FEEDBACK TABLE
-- =====================================================
INSERT INTO feedback (
    id, user_id, test_id, rating_content, rating_difficulty, 
    rating_ux, comments, created_at
) VALUES 
('feedback_1', '1', 'test1', 4, 3, 5, 'Good test, but some questions were too easy', '2025-01-15T11:30:00Z'),
('feedback_2', '1', 'test2', 3, 4, 4, 'Challenging questions, need more practice', '2025-01-10T15:30:00Z'),
('feedback_3', '1', 'test_ch3', 5, 3, 5, 'Excellent content and explanations', '2025-01-15T09:45:00Z'),
('feedback_4', '1', 'test_ch4', 4, 3, 4, 'Good test, explanations were helpful', '2025-01-15T10:45:00Z');

-- =====================================================
-- 14. MAINS_QUESTIONS TABLE (if exists)
-- =====================================================
INSERT INTO mains_questions (
    id, subject_id, question_text, hint, word_limit, 
    topic, marks, sample_answer, created_at, updated_at
) VALUES 
('mains_1', 'polity', 'Discuss the significance of the Preamble to the Indian Constitution. How does it reflect the philosophy of the Constitution?', 'Consider the key words in the Preamble and their constitutional implications', 200, 'Preamble', 10, 'The Preamble is the soul of the Constitution...', '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),
('mains_2', 'polity', 'Analyze the relationship between Fundamental Rights and Directive Principles of State Policy. How has the Supreme Court interpreted this relationship?', 'Refer to cases like Minerva Mills, Kesavananda Bharati', 250, 'Fundamental Rights', 15, NULL, '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z'),
('mains_3', 'polity', 'Examine the role of the Supreme Court as the guardian of the Constitution. Discuss with reference to recent judgments.', 'Consider judicial review, constitutional interpretation, and recent cases', 300, 'Judiciary', 20, NULL, '2024-10-01T00:00:00Z', '2024-10-01T00:00:00Z');

-- =====================================================
-- 15. TEST_QUESTIONS TABLE (Junction table)
-- =====================================================
INSERT INTO test_questions (
    id, test_id, question_id, question_order, created_at
) VALUES 
-- Test 3 Questions
('tq_1', 'test3', 'q1', 1, '2024-10-01T00:00:00Z'),
('tq_2', 'test3', 'q2', 2, '2024-10-01T00:00:00Z'),
('tq_3', 'test3', 'q3', 3, '2024-10-01T00:00:00Z'),
('tq_4', 'test3', 'q4', 4, '2024-10-01T00:00:00Z'),
('tq_5', 'test3', 'q5', 5, '2024-10-01T00:00:00Z'),

-- Chapter Tests
('tq_6', 'test_ch1', 'q1_ch1', 1, '2024-10-01T00:00:00Z'),
('tq_7', 'test_ch1', 'q2_ch1', 2, '2024-10-01T00:00:00Z'),
('tq_8', 'test_ch2', 'q1_ch2', 1, '2024-10-01T00:00:00Z'),
('tq_9', 'test_ch3', 'q1_ch3', 1, '2024-10-01T00:00:00Z'),
('tq_10', 'test_ch4', 'q1_ch4', 1, '2024-10-01T00:00:00Z'),
('tq_11', 'test_ch5', 'q1_ch5', 1, '2024-10-01T00:00:00Z'),
('tq_12', 'test_ch6', 'q1_ch6', 1, '2024-10-01T00:00:00Z'),
('tq_13', 'test_ch7', 'q1_ch7', 1, '2024-10-01T00:00:00Z'),
('tq_14', 'test_ch8', 'q1_ch8', 1, '2024-10-01T00:00:00Z'),
('tq_15', 'test_ch9', 'q1_ch9', 1, '2024-10-01T00:00:00Z'),
('tq_16', 'test_ch10', 'q1_ch10', 1, '2024-10-01T00:00:00Z'),

-- Full Length Test
('tq_17', 'polity_full_test', 'q1_full', 1, '2024-10-01T00:00:00Z');

-- =====================================================
-- ✅ DATABASE POPULATION COMPLETE
-- =====================================================
-- 
-- Summary of data inserted:
-- - 1 user
-- - 3 subjects (Polity, Geography, Economy)
-- - 16 chapters (10 Polity + 3 Geography + 3 Economy)
-- - 19 tests (10 chapter tests + 1 full length + 8 practice tests)
-- - 17 questions with 68 options
-- - 4 quarterly exams with 16 exam papers
-- - 5 user attempts with 20 responses
-- - 9 progress records
-- - 10 analytics records
-- - 4 feedback records
-- - 3 mains questions
-- - 17 test-question mappings
-- 
-- Total records: 172+
-- =====================================================
