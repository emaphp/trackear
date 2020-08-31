export interface Option {
    id: number,
    title: string,
    summary: string
}

export interface FeedbackFormState {
    selectedOption: number | undefined,
    summary: string
}
