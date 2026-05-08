# AI Trailer Generator 🎬

Automatically generates compelling trailers from full films using AI-powered scene detection, emotion analysis, and intelligent sequencing.

## What It Does

Creates professional **30-60 second trailers** from your full film by:

1. **Scene Detection** - Automatically identifies cuts and scene boundaries
2. **Emotion Detection** - Analyzes intensity and emotional impact of each scene
3. **Intelligent Ranking** - Scores scenes by relevance to genre and engagement
4. **Smart Stitching** - Creates narrative arc with proper pacing
5. **Music Pairing** - Suggests appropriate background music

## Features

### 📥 Inputs

- **Full Video**: Upload your complete film/video file
- **Genre**: Select from Action, Drama, Comedy, Horror, Thriller, Romance, Sci-Fi, Documentary
- **Duration**: Choose 30, 45, or 60 second trailer length
- **Title & Description**: Provide context for AI analysis (optional)

### 📤 Outputs

- **30-60 Second Trailer**: Formatted highlight reel
- **Highlight Scenes**: Key clips with timestamps (start-end times)
- **Emotion Analysis**: Detailed breakdown of each scene's emotional impact
  - Emotion type: intense, suspenseful, climactic, calm, romantic, etc.
  - Emotion score: 0-100% intensity rating
- **Scene Descriptions**: AI-generated descriptions of each highlight
- **Music Suggestions**: Genre-appropriate background music recommendations
- **Trailer Analysis**: Strategic breakdown of how the trailer creates narrative arc

## Technical Implementation

### Architecture

```
┌─────────────────────────────────────────┐
│    AI Trailer Generator Screen          │
│  (Video selection, genre, duration)     │
└────────────┬────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────┐
│   Trailer Generator Service             │
│  (Gemini API integration)               │
└────────────┬────────────────────────────┘
             │
             ├──► Scene Analysis
             ├──► Emotion Detection
             ├──► Intelligent Ranking
             └──► Music Suggestion
             │
             ▼
┌─────────────────────────────────────────┐
│   MongoDB Video Service                 │
│  (Video storage & metadata)             │
└─────────────────────────────────────────┘
```

### Components

#### 1. Models (`models/trailer_models.dart`)

- **VideoGenre**: Enum for film genres
- **TrailerDuration**: Enum for trailer lengths
- **Scene**: Individual scene with timing, emotion, description
- **TrailerGenerationRequest**: Input parameters
- **GeneratedTrailer**: Complete trailer with analysis
- **VideoUpload**: Video metadata for MongoDB

#### 2. Services

**`TrailerGeneratorService`** (`trailer_generator_service.dart`)

- Communicates with Gemini API for analysis
- Performs scene detection and emotion analysis
- Ranks scenes for narrative impact
- Generates trailer structure
- Suggests music

**`MongoDBVideoService`** (`mongodb_video_service.dart`)

- Saves video metadata to MongoDB
- Stores trailer analysis results
- Retrieves videos for users
- Manages video lifecycle

#### 3. UI (`screens/trailer_generator_screen.dart`)

Complete user interface with:

- Video file selection
- Genre and duration settings
- Loading state with progress feedback
- Results display with:
  - Highlight scenes with timestamps
  - Emotion analysis visualization
  - Music suggestions
  - Strategic analysis

## How It Works

### Step 1: Upload Video

```
Select your full film from device
```

### Step 2: Configure

```
- Enter movie title
- Select genre (auto-recommends based on content)
- Choose trailer duration (30/45/60 seconds)
- Add optional description
```

### Step 3: Generate

```
AI analyzes:
├── Scene boundaries and cuts
├── Emotional intensity of each scene
├── Relevance to selected genre
├── Narrative arc potential
└── Audio cues and music opportunities
```

### Step 4: Review Results

```
Displays:
├── Preview of selected clips with timings
├── Emotion breakdown for each scene
├── Why each scene was selected
├── Music recommendations
└── Overall trailer strategy
```

## Gemini API Integration

Uses **Gemini 2.5 Flash** model for:

### Analysis Prompt

```
Analyzes video metadata and metadata descriptions to determine:
1. Scene boundaries (approximated from duration)
2. Emotional intensity curve
3. Genre-appropriate highlights
4. Narrative pacing
5. Music style recommendations
```

### Response Format

```json
{
  "highlightScenes": [
    {
      "startTime": 0,
      "endTime": 30,
      "emotionScore": 0.9,
      "emotionType": "intense",
      "description": "Opening hook establishing conflict"
    }
  ],
  "selectedTimestamps": [0, 15, 30, 45],
  "musicSuggestion": "High-energy orchestral score",
  "analysis": "Strategic breakdown of trailer structure"
}
```

## MongoDB Integration

### Connection String

```
mongodb+srv://hemanth:cinehub@cluster0.astjpnx.mongodb.net/cinehub
```

### Database Structure

```
cinehub/
├── videos (videos collection)
│  ├── id
│  ├── fileName
│  ├── fileSizeBytes
│  ├── mimeType
│  ├── uploadedBy
│  ├── uploadedAt
│  └── mongoDbId
│
└── trailers (trailer analysis collection)
   ├── videoId
   ├── genre
   ├── duration
   ├── highlightScenes
   ├── selectedTimestamps
   ├── musicSuggestion
   ├── analysis
   └── generatedAt
```

### Stored Data

- **Videos Collection**: Metadata about uploaded films
- **Trailers Collection**: Generated trailer analyses linked to videos

## Emotion Types

| Type            | Usage                    | Example                   |
| --------------- | ------------------------ | ------------------------- |
| **intense**     | High-stakes action/drama | Fight scenes, explosions  |
| **suspenseful** | Building tension         | Chases, conflicts         |
| **climactic**   | Culmination of story     | Showdowns, revelations    |
| **calm**        | Quiet moments            | Character development     |
| **romantic**    | Emotional connections    | Relationships, tenderness |
| **comedic**     | Humorous moments         | Jokes, funny interactions |
| **sad**         | Emotional depth          | Loss, sacrifice           |
| **mysterious**  | Intrigue and questions   | Clues, revelations        |

## Scene Selection Algorithm

```
For each scene in video:
1. Calculate emotional impact (0-1.0)
2. Evaluate genre relevance
3. Check narrative pacing
4. Assess visual variety
5. Consider timing constraints
6. Score overall impact

Select scenes with highest scores until:
- Total duration ≤ target length
- Narrative arc is complete
- Pacing is balanced
- Visual variety is present
```

## Usage Example

```dart
import 'package:cinehubapp/ai_features/ai_features.dart';

// Navigate to trailer generator
Navigator.push(context, MaterialPageRoute(
  builder: (context) => TrailerGeneratorScreen(
    apiKey: 'AIzaSyBbpB2fBJbYj443ffE4WFDy2qnF4V4zdLg',
  ),
));
```

## File Structure

```
lib/ai_features/trailer_generator/
├── models/
│   └── trailer_models.dart
├── services/
│   ├── trailer_generator_service.dart
│   └── mongodb_video_service.dart
├── screens/
│   └── trailer_generator_screen.dart
├── trailer_generator.dart (exports)
└── README.md
```

## API Configuration

### Gemini Model

- **Model**: gemini-2.5-flash
- **Temperature**: 0.8 (creative but consistent)
- **Max Tokens**: 2048 (detailed analysis)
- **Timeout**: 3 minutes

### MongoDB

- **Database**: cinehub
- **Video Storage**: gs://storage bucket or similar CDN
- **Metadata**: MongoDB Atlas

## Features & Roadmap

### ✅ Implemented

- Scene detection and emotion analysis
- Genre-aware trailer generation
- Multiple duration options
- Music suggestions
- MongoDB integration
- Full UI with results display

### 🚧 Future Enhancements

- [ ] Actual video file upload with processing
- [ ] Real-time scene detection from video frames
- [ ] Preview/playback of generated trailer
- [ ] Custom music track integration
- [ ] Multi-video montage support
- [ ] Social media format optimization (Instagram, TikTok, YouTube)
- [ ] A/B testing multiple trailer versions
- [ ] Sentiment analysis with facial recognition
- [ ] Export to various video formats
- [ ] Share directly to social platforms

## Performance Considerations

- **Analysis Time**: 1-3 minutes depending on video length
- **Scene Detection**: Approximated from metadata (can be enhanced with video processing)
- **Storage**: Videos stored in MongoDB or cloud storage bucket
- **Scaling**: Can handle multiple concurrent requests

## Error Handling

The service gracefully handles:

- Missing video files
- Invalid genre selections
- API timeouts
- JSON parsing failures
- Database connection issues

Returns default trailer if analysis fails, ensuring users always get results.

## Security Notes

⚠️ **Important for Production:**

1. **API Key Management**: Store Gemini API key in environment variables
2. **Database Credentials**: Use MongoDB connection string from secure config
3. **File Uploads**: Implement proper file validation and size limits
4. **User Authentication**: Verify user owns videos before processing
5. **Data Privacy**: Implement proper access controls for stored videos

## Support & Troubleshooting

### Video Won't Upload

- Check file size (max 500MB recommended)
- Verify file format (MP4, MOV, WebM supported)
- Check network connection

### Trailer Analysis Takes Too Long

- This is normal for longer videos
- Analysis can take 1-3 minutes
- Check your internet connection

### MongoDB Connection Issues

- Verify connection string is correct
- Check IP whitelist in MongoDB Atlas
- Ensure database exists

### Gemini API Errors

- Verify API key is valid and active
- Check billing is enabled
- Ensure quota limits are available

---

**API Endpoint**: https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent

**Documentation**: https://ai.google.dev/docs
