# CineHub Integration - Quick Reference Guide

**Current Status:** Integration planning COMPLETE  
**Ready to Begin:** Implementation Phase  
**Current Branch:** integration-dev  
**Backup Available:** test-backup

---

## GIT BRANCH STRUCTURE

```
main (WORKING BACKEND)
├── Branch from: origin/main
├── State: Production backend ready
├── Use: Base for integration-dev
└── Status: ✅ PRESERVED

test (MODERN UI)
├── Branch from: origin/test
├── State: Modern screens + incomplete backend
├── Merged: nanda-dev + Vamsi's-Film
└── Status: ✅ BACKED UP (test-backup)

integration-dev (TARGET BRANCH)
├── Branch from: main
├── State: Main + planning docs
├── Next: Add TEST UI + keep MAIN backend
└── Status: 🔄 READY FOR IMPLEMENTATION

test-backup (SAFETY COPY)
├── Branch from: test
├── State: Snapshot of test before integration
├── Use: Rollback if needed
└── Status: ✅ PRESERVED
```

---

## THREE KEY DOCUMENTS

### 1. INTEGRATION_EXECUTIVE_SUMMARY.md

**Read This First** - 5 min read

- Overview of strategy
- What was analyzed
- Success criteria
- Next steps

### 2. INTEGRATION_ANALYSIS.md

**Technical Analysis** - 15 min read

- Branch comparison table
- File preservation checklist
- Integration strategy details
- Risk assessment

### 3. INTEGRATION_IMPLEMENTATION_PLAN.md

**Step-by-Step Guide** - Implementation reference

- 8 phases with details
- Specific code examples
- Validation checklist
- Rollback procedures

---

## QUICK START: 5 STEPS

### Step 1: Understand the Strategy

```
Read: INTEGRATION_EXECUTIVE_SUMMARY.md (5 min)

Key Takeaway:
- Keep MAIN's working backend
- Bring TEST's modern UI
- Selective merge, not forced merge
```

### Step 2: Review File Preservation List

```
Read: INTEGRATION_ANALYSIS.md → "Integration Checklist"

What to keep from MAIN:
✅ server.js (Twilio SMS)
✅ Authentication logic
✅ .env configuration
✅ User models
✅ Backend services

What to bring from TEST:
✅ Screen UIs (home, discover, chat, etc.)
✅ Widgets (reusable components)
✅ Responsive layouts
✅ Modern theme
```

### Step 3: Start Implementation

```
Follow: INTEGRATION_IMPLEMENTATION_PLAN.md → Phase 4

Current Step:
1. Update pubspec.yaml (merge dependencies)
2. Cherry-pick screens from TEST
3. Update imports & paths
4. Fix API integration
5. Test authentication
```

### Step 4: Validate Integration

```
Run through: INTEGRATION_IMPLEMENTATION_PLAN.md → Phase 6

Check:
✅ App starts without errors
✅ Login screen appears
✅ OTP verification works
✅ JWT token obtained
✅ All screens responsive
✅ Navigation works
```

### Step 5: Merge to Main

```
When ready:
git checkout main
git merge integration-dev
git push origin main
```

---

## COMMAND REFERENCE

### VIEW STRATEGY

```bash
# Current integration branch
git checkout integration-dev

# Read planning docs
cat INTEGRATION_EXECUTIVE_SUMMARY.md
cat INTEGRATION_ANALYSIS.md
cat INTEGRATION_IMPLEMENTATION_PLAN.md
```

### VIEW BRANCHES

```bash
# List all branches
git branch -a

# Show detailed branch info
git log --oneline --all --graph --decorate

# Compare branches
git diff main test -- lib/screens/
```

### CHERRY-PICK FROM TEST

```bash
# When ready to implement
git checkout integration-dev

# Show files different in test
git diff main test --name-only

# Copy specific file from test
git checkout test -- lib/screens/discover_screen.dart

# Review changes
git diff HEAD
```

### ROLLBACK SAFETY

```bash
# See all recent changes
git reflog

# Restore from backup
git checkout test-backup

# Or hard reset
git reset --hard HEAD~1
```

---

## BACKEND VERIFICATION CHECKLIST

Before starting integration, verify MAIN backend is intact:

```bash
# Check backend files exist
ls -la backend/
# Should have: server.js, send_sms.js, verify_check.js

# Check .env is configured
cat backend/.env.example

# Verify port 4000 configuration
grep "port" backend/server.js

# Check Twilio setup
grep "TWILIO" backend/server.js

# Check JWT setup
grep "JWT_SECRET" backend/server.js
```

---

## CRITICAL API ENDPOINTS

These endpoints must work after integration:

```
Backend: https://cinehub-qltm.onrender.com/api/v1

Authentication:
POST   /auth/send-otp        (Twilio SMS)
POST   /auth/verify-otp      (Verify + JWT)
POST   /auth/signup          (Create user)
POST   /auth/login           (Authenticate)

User Data:
GET    /users/:id            (Get profile)
PATCH  /users/:id            (Update profile)

AI Features:
GET    /ai/scripts
POST   /ai/generate
```

All must include JWT token:

```
Header: Authorization: Bearer <JWT_TOKEN>
```

---

## RESPONSIVE DESIGN FIX CHECKLIST

After bringing TEST UI, ensure responsive:

```
Phone (360dp):
✅ All text readable
✅ No overflow
✅ Buttons tappable
✅ Forms usable

Tablet (600dp):
✅ Content centered
✅ Proper spacing
✅ No stretched images
✅ Navigation accessible

Desktop (1024dp+):
✅ Multiple columns
✅ Full layout
✅ Proper scaling
```

Tools needed:

- LayoutBuilder (adapt to screen width)
- MediaQuery (get device size)
- Flexible/Expanded (fill available space)
- GridView (responsive grids)

---

## FILE ORGANIZATION AFTER INTEGRATION

Target structure:

```
lib/
├── main.dart                    (Entry point)
├── app.dart                     (App configuration)
├── features/
│   ├── auth/                    (Authentication)
│   │   ├── data/services/
│   │   ├── presentation/
│   │   └── domain/
│   ├── home/                    (Home screen)
│   ├── discover/                (Discover screen)
│   ├── chat/                    (Chat screen)
│   ├── ai/                      (AI features)
│   └── ... (other features)
└── shared/
    ├── widgets/                 (Reusable UI)
    ├── theme/                   (Colors, fonts)
    ├── services/                (API, storage)
    ├── models/                  (Data models)
    └── utils/                   (Helpers)
```

---

## COMMON ISSUES & FIXES

### Issue: "Backend endpoint not found"

```
Fix:
1. Check URL: https://cinehub-qltm.onrender.com
2. Check endpoint path matches API
3. Verify JWT token included in headers
4. Check network connectivity
```

### Issue: "OTP not received"

```
Fix:
1. Check Twilio credentials in .env
2. Verify phone number format (+country code)
3. Check SMS sending logic in send_sms.js
4. Review Twilio logs for errors
```

### Issue: "JWT token invalid/expired"

```
Fix:
1. Check token storage mechanism
2. Verify token refresh logic
3. Ensure expiry time set correctly
4. Check JWT_SECRET matches backend
```

### Issue: "Responsive layout broken"

```
Fix:
1. Remove hardcoded dimensions
2. Use LayoutBuilder for dynamic sizing
3. Use MediaQuery for device-aware layouts
4. Test on multiple screen sizes
```

---

## TESTING WORKFLOW

### Manual Testing Order

1. **Auth Flow** (Most critical)
   - Open login screen
   - Enter phone number
   - Receive OTP via SMS
   - Enter OTP
   - Receive JWT token
   - Access main app

2. **Navigation**
   - Navigate between screens
   - Test back button
   - Verify routing

3. **Responsive Design**
   - Test on 360dp (phone)
   - Test on 600dp (tablet)
   - Test on 1024dp (desktop)

4. **API Integration**
   - Make API calls
   - Verify JWT sent in headers
   - Check response handling

5. **Error Handling**
   - Test invalid OTP
   - Test network failure
   - Test token expiry

---

## SUCCESS DEFINITION

Integration is successful when:

✅ App runs without console errors  
✅ Login screen appears with modern UI  
✅ OTP sends via Twilio SMS  
✅ JWT token received and stored  
✅ Can navigate to home screen  
✅ All screens responsive  
✅ API calls work with JWT  
✅ No hardcoded dimensions  
✅ Backend compatibility maintained  
✅ Production build succeeds

---

## SUPPORT RESOURCES

### Documents on integration-dev Branch

- INTEGRATION_EXECUTIVE_SUMMARY.md (Start here)
- INTEGRATION_ANALYSIS.md (Technical details)
- INTEGRATION_IMPLEMENTATION_PLAN.md (Implementation guide)
- backend/ (Working backend reference)
- lib/ (Current app structure)

### External Resources

- Flutter Documentation: https://flutter.dev
- Go Router Guide: https://pub.dev/packages/go_router
- Twilio SMS: https://www.twilio.com/docs
- Backend API: https://cinehub-qltm.onrender.com

---

## TIMELINE SUMMARY

| Phase              | Duration     | Status    |
| ------------------ | ------------ | --------- |
| Analysis           | ✅ DONE      | Complete  |
| Planning           | ✅ DONE      | Complete  |
| Branch Setup       | ✅ DONE      | Complete  |
| **Implementation** | ~1 hour      | ➡️ NEXT   |
| **Testing**        | ~1 hour      | Later     |
| **Finalization**   | ~30 min      | Later     |
| **TOTAL**          | **~3 hours** | 🎯 TARGET |

---

## NEXT ACTION

### You are here:

```
✅ Test branch backed up
✅ Analysis complete
✅ Planning documents created
✅ integration-dev branch ready

👇 Next Step:
```

### Start Implementation:

```
1. Read INTEGRATION_EXECUTIVE_SUMMARY.md (5 min)
2. Read relevant section of IMPLEMENTATION_PLAN.md
3. Begin Phase 4 - Step by step
4. Test as you go
5. Validate before merge
```

---

**Ready to proceed? Begin with:**  
`INTEGRATION_EXECUTIVE_SUMMARY.md`

**Then follow:**  
`INTEGRATION_IMPLEMENTATION_PLAN.md` → Phase 4

**Questions? Check:**  
`INTEGRATION_ANALYSIS.md`
